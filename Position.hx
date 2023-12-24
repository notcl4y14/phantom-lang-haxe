class Position {
	public var index: Int;
	public var line: Int;
	public var column: Int;

	public function new(index: Int, line: Int, column: Int) {
		this.index = index;
		this.line = line;
		this.column = column;
	}

	public function advance(?char: String, delta: Int = 1) {
		this.index += delta;
		this.column += delta;

		if (char == "\n") {
			this.column = 0;
			this.line += 1;
		}

		return this;
	}

	public function clone() {
		return new Position(this.index, this.line, this.column);
	}
}