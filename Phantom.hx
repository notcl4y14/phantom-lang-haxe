class Phantom {

	static public function usage() {
		var lines = sys.io.File.read("assets/usage.txt")
			.readAll();

		Sys.println(lines);
	}
	
	public function new() {
		var args = Sys.args();

		if (
			args.length == 0 ||
			args.contains("--help")
		) {
			Phantom.usage();
			return;
		}

		Sys.println("Hello World!");
		Sys.println( new Token(TokenType.String, "lol").string() );
	}

	static public function main() {
		var app = new Phantom();
	}
}