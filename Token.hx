class Token {
	public var type: TokenType;
	public var value: Any;
	public var position: Array<Position>;

	public function new(type: TokenType, ?value: Any) {
		this.type = type;
		this.value = value;
		this.position = [];
	}

	public function getPosition(number: Int) {
		return this.position[number];
	}

	public function setPosition(position: Array<Position>) {
		this.position = position;

		// If the position array does not have a right position
		if (this.position.length == 1) {
			this.position[1] = this.position[0].clone().advance();
		}

		return this;
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