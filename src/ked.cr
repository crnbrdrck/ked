require "option_parser"
require "./ked/*"

# Ked is the first scripting language to come out of [The People's Republic of Cork](http://en.wikipedia.org/wiki/Cork_\(city\).
#
# The docs that follow are indepth documentation for the interpreter for Ked.
# NOTE: These docs should not be used to learn the language, they are for people who wish to contribute to the language.
module Ked
end

banner = "\u001b[31mked\u001b[0m: The first Corkonian scripting language.
See the language specification at https://adamlynch.com/ked/.

Currently this interpreter is a WIP. It doesn't even interpret anything yet.

Supported features:\u001b[36m
  - Lexing tokens
  - A REPL environment that lexes whatever you type in stdin
\u001b[0m
To see the code and maybe even contribute, visit https://github.com/crnbrdrck/ked

Usage:
  ked [options] [file] - Run the script called `file`
    - If no file is passed in, starts the REPL environment instead

  Options:"

# option vars
version = false
# debug = false
help = false

option_parser = OptionParser.new
option_parser.banner = banner
# option_parser.on("-d", "--debug", "Print the status of the global variable scope after parsing the script") { debug = true }
option_parser.on("-h", "--help", "Show this help message") { help = true }
option_parser.on("-v", "--version", "Print version information") { version = true }

# Entrypoint; get the file to execute from argv and attempt to run it (for now, print out global scope)
if ARGV.size == 0
  # Here we want to enter the REPL loop
  puts "\u001b[31mked\u001b[0m version #{Ked::VERSION}"
  Ked::REPL.new
else
  option_parser.parse!
  # Check if the user wants the version information
  if version
    puts "\u001b[31mked\u001b[0m version #{Ked::VERSION}"
    Process.exit 0
  end
  # If not, get the file name from argv and run it
  # With the options, the filename should now be the last argument
  if help
    puts option_parser
    Process.exit 0
  end
  file = ARGV[-1]
  begin
    text = File.read file
  rescue
    puts "\u001b[31mFile '#{file}' could not be read\u001b[0m"
    Process.exit 1
  end
  # interpreter = Ked::Interpreter.new text
  # interpreter.interpret

  # # If the user has specified debug, print the global scope
  # if debug
  #   puts interpreter.global_scope
  # end
end
