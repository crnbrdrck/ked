require "option_parser"
require "./ked/*"

# TODO: Write documentation for `Ked`
module Ked
  # NO_INPUT_FILE: help message to display when no input file is specified for the interpreter
  HELP_TEXT_FOREWARD = "\u001b[31mked\u001b[0m: The first Corkonian scripting language.
See the language specification at https://adamlynch.com/ked/.

Currently this interpreter is a WIP.
Supported features:\u001b[36m
  - Variable assignment
\u001b[0m
To see the code and maybe even contribute, visit https://github.com/crnbrdrck/ked

Usage:
  ked [options] feen.ked - Run the script called `feen.ked` and print the global variable scope of the interpreter after interpreting the whole thing

  Options:"
end

# option vars
version = false
debug = false

parser = OptionParser.new
parser.banner = Ked::HELP_TEXT_FOREWARD
parser.on("-d", "--debug", "Print the status of the global variable scope after parsing the script") { debug = true }
parser.on("-h", "--help", "Show this help message") { puts parser }
parser.on("-v", "--version", "Print version information") { version = true }

# Entrypoint; get the file to execute from argv and attempt to run it (for now, print out global scope)
if ARGV.size == 0
  puts parser
else
  parser.parse!
  # Check if the user wants the version information
  if version
    puts "\u001b[31mked\u001b[0m version #{Ked::VERSION}"
    Process.exit 0
  end
  # If not, get the file name from argv and run it
  # With the options, the filename should now be the last argument
  file = ARGV[-1]
  begin
    text = File.read file
  rescue
    puts "\u001b[31mFile '#{file}' could not be read\u001b[0m"
    Process.exit 1
  end
  interpreter = Ked::Interpreter.new text
  interpreter.interpret

  # If the user has specified debug, print the global scope
  if debug
    puts interpreter.global_scope
  end
end
