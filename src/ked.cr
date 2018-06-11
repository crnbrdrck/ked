require "./ked/*"

# TODO: Write documentation for `Ked`
module Ked
  # TODO: Put your code here
end

# Run the main loop
while true
  begin
    print "calc> "
    text = gets(chomp: true)
  rescue
    break
  end
  if text
    # Try and interpret the text
    interpreter = Ked::Interpreter.new text
    puts interpreter.interpret
  end
end
