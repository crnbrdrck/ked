require "./ked/*"

# TODO: Write documentation for `Ked`
module Ked
  # NO_INPUT_FILE: help message to display when no input file is specified for the interpreter
  NO_INPUT_FILE = "\u001b[31mked\u001b[0m: The first Corkonian scripting language.
See the language specification at https://adamlynch.com/ked/.

Currently this interpreter is a WIP.
Supported features:\u001b[36m
  - Variable assignment
\u001b[0m
To see the code and maybe even contribute, visit https://github.com/crnbrdrck/ked

Usage:
  ked feen.ked - Run the script called `feen.ked` and print the global variable scope of the interpreter after interpreting the whole thing

"
end

# Entrypoint; get the file to execute from argv and attempt to run it (for now, print out global scope)
if ARGV.size == 0
  puts Ked::NO_INPUT_FILE
else
  # Get the file name from argv and run it
  file = ARGV[0]
  begin
    text = File.read file
  rescue
    puts "\u001b[31mFile '#{file}' could not be read\u001b[0m"
    Process.exit 1
  end
  interpreter = Ked::Interpreter.new text
  interpreter.interpret
  puts interpreter.global_scope
end
