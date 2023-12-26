class Result {
	public var result: Dynamic;
	public var callback: Int;
	public var error: Error;

	public function new(result: Dynamic, callback: Int, error: Error) {
		this.result = result;
		this.callback = callback;
		this.error = error;
	}
}

class Lexer {
	public var filename: String;
	public var code: String;
	public var position: Position;

	public function new(filename: String, code: String) {
		this.filename = filename;
		this.code = code;
		this.position = new Position(-1, 0, -1);

		this.advance();
	}

	public function getCode() {
		return this.code;
	}

	public function getPosition() {
		return this.position;
	}

	public function at(range: Int = 1) {
		var position = this.getPosition().index;
		return this.code.substr(position, range);
	}

	public function advance(delta: Int = 1) {
		this.getPosition().advance(this.at(), delta);
	}

	public function isEof() {
		return this.getPosition().index >= this.getCode().length;
	}

	// ---------------------------------------------------------------------

	public function lexerize() {
		var list = [];

		while (!this.isEof()) {
			var res = this.lexerizeToken();
			var leftPosition = this.getPosition().clone();

			// TODO: Make an error
			if (res.callback >= 1) {
				var char = this.at();
				var rightPosition = this.getPosition().advance().clone();

				return new Result(null, 0, new Error(this.filename,
						[leftPosition, rightPosition],
						'Undefined character \'${char}\''
					)
				);
			}

			var token = res.result;

			if (token.position[0] == null) {
				token.position[0] = leftPosition;
			}

			if (token.position[1] == null) {
				token.position[1] = leftPosition.clone().advance();
			}

			list.push(token);
			this.advance();
		}

		return new Result(list, 0, null);
	}

	public function lexerizeToken() {
		var char = this.at();
		var result = null;
		var callback = 0;

		// Whitespace
		if ( StringTools.contains(" \t\r\n", char) ) {
			// Skip

		// Multicharacter Operators
		} else if ( ["+=", "-=", "*=", "/=", "%=", "^=", "==", "!=", "<=", ">="].contains(this.at(2)) ) {
			result = new Token(TokenType.Operator, this.at(2));
			this.advance();

		// Operators
		} else if ( StringTools.contains("+-*/%^=<>", char) ) {
			result = new Token(TokenType.Operator, char);

		// Symbols
		} else if ( StringTools.contains(".,:;&|!", char) ) {
			switch (char) {
				case ".": result = new Token(TokenType.Dot);
				case ",": result = new Token(TokenType.Comma);
				case ":": result = new Token(TokenType.Colon);
				case ";": result = new Token(TokenType.Semicolon);
				case "&": result = new Token(TokenType.Ampersand);
				case "|": result = new Token(TokenType.Pipe);
				case "!": result = new Token(TokenType.Not);
			}

		// Closures
		} else if ( StringTools.contains("()[]{}", char) ) {
			switch (char) {
				case "(": result = new Token(TokenType.Paren, 0);
				case ")": result = new Token(TokenType.Paren, 1);
				case "[": result = new Token(TokenType.Bracket, 0);
				case "]": result = new Token(TokenType.Bracket, 1);
				case "{": result = new Token(TokenType.Brace, 0);
				case "}": result = new Token(TokenType.Brace, 1);
			}

		// Number
		} else if ( StringTools.contains("1234567890", char) ) {
			result = this.lexerizeNumber();

		// String
		} else if ( StringTools.contains("\"'`", char) ) {
			result = this.lexerizeString();

		// Identifier | Literal | Keyword
		} else if ( StringTools.contains("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_", char) ) {
			result = this.lexerizeIdentifier();

		} else {
			callback = 1;
		}

		return new Result(result, callback, null);
	}

	// ---------------------------------------------------------------------

	public function lexerizeNumber() {
		var numStr = "";
		var dot = false;
		var leftPosition = this.getPosition().clone();

		while (!this.isEof() && StringTools.contains("1234567890.", this.at())) {
			if (this.at() == ".") {
				if (dot) break;
				dot = true;
			}

			numStr += this.at();
			this.advance();
		}

		var rightPosition = this.getPosition().clone();
		this.advance(-1);

		return new Token(TokenType.Number, Std.parseInt(numStr))
			.setPosition([leftPosition, rightPosition]);
	}

	public function lexerizeString() {
		var str = "";
		var quote = this.at();
		var leftPosition = this.getPosition().clone();

		this.advance();

		while (!this.isEof() && this.at() != quote) {
			str += this.at();
			this.advance();
		}

		var rightPosition = this.getPosition().clone();

		return new Token(TokenType.String, str)
			.setPosition([leftPosition, rightPosition]);
	}

	public function lexerizeIdentifier() {
		var identStr = "";
		var leftPosition = this.getPosition().clone();

		while (!this.isEof() && StringTools.contains("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_1234567890", this.at())) {
			identStr += this.at();
			this.advance();
		}

		var rightPosition = this.getPosition().clone();
		this.advance(-1);

		if (["undefined", "null", "true", "false"].contains(identStr)) {
			return new Token(TokenType.Literal, identStr)
				.setPosition([leftPosition, rightPosition]);

		} else if (["let", "var", "if", "else", "while", "for", "function"].contains(identStr)) {
			return new Token(TokenType.Keyword, identStr)
				.setPosition([leftPosition, rightPosition]);
		}

		return new Token(TokenType.Identifier, identStr)
			.setPosition([leftPosition, rightPosition]);
	}
}