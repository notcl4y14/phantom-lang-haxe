class Lexer {
	public var code: String;
	public var pos: Int;

	public function new(code: String) {
		this.code = code;
		this.pos = -1;

		this.advance();
	}

	public function getPos() {
		return this.pos;
	}

	public function at(range: Int = 1) {
		var position = this.getPos();
		return this.code.substr(position, range);
	}

	public function advance(delta: Int = 1) {
		this.pos += delta;
	}

	public function isEof() {
		return this.getPos() >= this.code.length;
	}

	// ---------------------------------------------------------------------

	public function lexerize() {
		var list = [];

		while (!this.isEof()) {
			var char = this.at();

			// Whitespace
			if ( StringTools.contains(" \t\r\n", char) ) {
				// Skip

			// Multicharacter Operators
			} else if ( ["+=", "-=", "*=", "/=", "%=", "^="].contains(this.at(2)) ) {
				list.push( new Token(TokenType.Operator, this.at(2)) );
				this.advance();

			// Operators
			} else if ( StringTools.contains("+-*/%^=", char) ) {
				list.push( new Token(TokenType.Operator, char) );

			// Symbols
			} else if ( StringTools.contains(".,:;&|!", char) ) {
				switch (char) {
					case ".": list.push ( new Token(TokenType.Dot) ); this.advance(); continue;
					case ",": list.push ( new Token(TokenType.Comma) ); this.advance(); continue;
					case ":": list.push ( new Token(TokenType.Colon) ); this.advance(); continue;
					case ";": list.push ( new Token(TokenType.Semicolon) ); this.advance(); continue;
					case "&": list.push ( new Token(TokenType.Ampersand) ); this.advance(); continue;
					case "|": list.push ( new Token(TokenType.Pipe) ); this.advance(); continue;
					case "!": list.push ( new Token(TokenType.Not) ); this.advance(); continue;
				}

			// Closures
			} else if ( StringTools.contains("()[]{}", char) ) {
				switch (char) {
					case "(": list.push ( new Token(TokenType.Paren, 0) ); this.advance(); continue;
					case ")": list.push ( new Token(TokenType.Paren, 1) ); this.advance(); continue;
					case "[": list.push ( new Token(TokenType.Bracket, 0) ); this.advance(); continue;
					case "]": list.push ( new Token(TokenType.Bracket, 1) ); this.advance(); continue;
					case "{": list.push ( new Token(TokenType.Brace, 0) ); this.advance(); continue;
					case "}": list.push ( new Token(TokenType.Brace, 1) ); this.advance(); continue;
				}

			// Number
			} else if ( StringTools.contains("1234567890", char) ) {
				list.push( this.lexerizeNumber() );

			// String
			} else if ( StringTools.contains("\"'`", char) ) {
				list.push( this.lexerizeString() );

			// Identifier | Literal | Keyword
			} else if ( StringTools.contains("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_", char) ) {
				list.push( this.lexerizeIdentifier() );
			}

			this.advance();
		}

		return list;
	}

	// ---------------------------------------------------------------------

	public function lexerizeNumber() {
		var numStr = "";
		var dot = false;

		while (!this.isEof()) {
			if (this.at() == ".") {
				if (dot) break;
				dot = true;
			}

			numStr += this.at();
			this.advance();
		}

		return new Token(TokenType.Number, Std.parseInt(numStr));
	}

	public function lexerizeString() {
		var str = "";
		var quote = this.at();

		this.advance();

		while (!this.isEof() && this.at() != quote) {
			str += this.at();
			this.advance();
		}

		return new Token(TokenType.String, str);
	}

	public function lexerizeIdentifier() {
		var identStr = "";

		while (!this.isEof() && StringTools.contains("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_1234567890", this.at())) {
			identStr += this.at();
			this.advance();
		}

		if (["undefined", "null", "true", "false"].contains(identStr)) {
			return new Token(TokenType.Literal, identStr);

		} else if (["let", "var", "if", "else", "while", "for", "function"].contains(identStr)) {
			return new Token(TokenType.Keyword, identStr);
		}

		return new Token(TokenType.Identifier, identStr);
	}
}