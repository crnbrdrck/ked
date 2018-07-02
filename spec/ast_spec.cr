require "./spec_helper"

describe Ked::AST do
  it "correctly returns a string equivalent of a program node" do
    expected_string = "remember €myVar = €anotherVar like"
    # Now create a program node that represents that input
    lexer = Ked::Lexer.new expected_string
    parser = Ked::Parser.new lexer
    program = parser.parse_program
    # Ensure that the parsed program node matches the input when printed out
    program.to_s.should eq expected_string
  end
end
