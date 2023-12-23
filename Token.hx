class Token {
	public var type: TokenType;
	public var value: Any;

	public function new(type: TokenType, ?value: Any) {
		this.type = type;
		this.value = value;
	}

	public function matches(type: TokenType, value: Any) {
		return this.type == type && this.value == value;
	}

	public function string() {
		var type = this.type;
		var value = this.value;

		return 'Token { type: ${type}, value: ${value} }';
	}
}