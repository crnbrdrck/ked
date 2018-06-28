require "./spec_helper"

describe Ked::Parser do
  describe "remember statements" do
    it "can correctly parse remember statements" do
      # examples/example3.ked contains examples of remember statements
      input = File.open "examples/example3.ked"
      lexer = Ked::Lexer.new input
      parser = Ked::Parser.new lexer

      program_node = parser.parse_program
      program_node.statements.size.should eq 2
      # Now check that the identifiers in the parsed program are correct
      expected_idents = [
        "x",
        "y",
      ]

      expected_idents.each.with_index do |expected_ident, index|
        test_statement = program_node.statements[index]
        # Check that the statement is a remember statement
        test_statement.token_literal.should eq "remember"
        # Try to cast to a RememberStatement
        test_remember_statement = test_statement.as Ked::AST::RememberStatement
        if test_remember_statement.nil?
          raise "Casting to RememberStatement failed"
        end
        # Check that the name token's value is the expected ident
        test_remember_statement.name.value.should eq expected_ident
        # Also check that the token_literal method returns the same
        test_remember_statement.name.token_literal.should eq expected_ident
      end
    end
  end
end
