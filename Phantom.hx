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

		var lexer = new Lexer("+-*/%^= += -= *= /= %= ^= .,:;&|! ()[]{} 0.5+2 `\"lol 'a'\"` x1 lol_foobar true false let var");
		var tokens = lexer.lexerize();

		for (token in tokens) {
			Sys.println(token.string());
		}
	}

	static public function main() {
		var app = new Phantom();
	}
}