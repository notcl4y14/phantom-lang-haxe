enum TokenType {
	// Values
	Number;
	String;
	Identifier;
	Keyword;
	Literal;

	Operator;

	// Symbols
	Dot;
	Comma;
	Semicolon;
	Colon;
	Ampersand;
	Pipe;
	Not;

	// Closures
	Paren;
	Bracket;
	Brace;

	// Misc.
	Comment;
	EOF;
}