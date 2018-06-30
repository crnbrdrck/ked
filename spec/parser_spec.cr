require "./spec_helper"

describe Ked::Parser do
  it "correctly generates errors when the tokens don't follow the syntax" do
    input = "remember x = 5 like
    remember € = 10 like
    remember €z 700 like"
    lexer = Ked::Lexer.new input
    parser = Ked::Parser.new lexer

    parser.parse_program
    parser.errors.size.should eq 3
    # Loop through the errors and print them out
    puts '\n'
    parser.errors.each do |e|
      puts e
    end
  end

  it "can correctly parse remember statements" do
    # examples/example3.ked contains examples of remember statements
    input = File.open "examples/example3.ked"
    lexer = Ked::Lexer.new input
    parser = Ked::Parser.new lexer

    program_node = parser.parse_program
    # Check that no errors are generated
    parser.errors.size.should eq 0
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

  it "can correctly parse return statements" do
    # examples/example4.ked contains an example of return statements
    input = File.open "examples/example4.ked"
    lexer = Ked::Lexer.new input
    parser = Ked::Parser.new lexer

    program_node = parser.parse_program
    # Check that no errors are generated
    parser.errors.size.should eq 0
    program_node.statements.size.should eq 1
    program_node.statements.each do |test_statement|
      # Check that the statement is a return statement
      test_statement.token_literal.should eq "hereYaGoBai"
      # Try to cast to a ReturnStatement
      test_remember_statement = test_statement.as Ked::AST::ReturnStatement
      if test_remember_statement.nil?
        raise "Casting to RememberStatement failed"
      end
    end
  end
end
