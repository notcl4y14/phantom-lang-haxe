class Error {
	public var filename: String;
	public var position: Array<Position>;
	public var details: String;

	public function new(filename: String, position: Array<Position>, details: String) {
		this.filename = filename;
		this.position = position;
		this.details = details;
	}

	public function string() {
		var filename = this.filename;
		var line = this.position[0].line == this.position[1].line
			? '${this.position[0].line + 1}'
			: '${this.position[0].line + 1} - ${this.position[1].line + 1}';
		var column = this.position[0].column == this.position[1].column
			? '${this.position[0].column + 1}'
			: '${this.position[0].column + 1} - ${this.position[1].column + 1}';
		var details = this.details;

		return '${filename}: ${line} : ${column} : ${details}';
	}
}