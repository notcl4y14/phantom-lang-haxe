class Phantom {

	static public function usage() {
		var lines = sys.io.File.read("assets/usage.txt")
			.readAll();

		Sys.println(lines);
	}

	public function run(code: String) {
		var lexer = new Lexer(code);
		var tokens = lexer.lexerize();

		for (token in tokens) {
			Sys.println(token.string());
		}
	}
	
	public function new() {
		var args = Sys.args();

		// Checking for some arguments
		if (args.contains("--help")) {
			Phantom.usage();
			return;
		}

		// Setting variables
		var filename: String = null;

		// Iterating arguments
		for (arg in args) {
			if (arg.substring(0, 1) == "-") {
				continue;
			}

			if (filename != null) {
				Sys.println("Filename already specified!");
				return;
			}

			filename = arg;
		}

		if (filename == null) {
			Sys.println("Please specify a filename!");
			return;
		}

		if (!sys.FileSystem.exists(filename)) {
			Sys.println('${filename} does not exist!');
			return;
		}

		var code = sys.io.File.read(filename)
			.readAll().toString();

		this.run(code);
	}

	static public function main() {
		var app = new Phantom();
	}
}