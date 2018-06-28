require "./spec_helper"

describe Ked::Lexer do
  describe "get_next_token" do
    it "should generate the correct list of tokens given the input `=+(){},€` (all single character tokens in ked)" do
      # Generate the input and pass it through the lexer to ensure it works correctly
      input = "=(){},€"
      # Generate a list of tokens that we expect
      filename = "<stdin>"
      expected = [
        Ked::Token.new(Ked::TokenType::ASSIGN, "="),
        Ked::Token.new(Ked::TokenType::LPAREN, "("),
        Ked::Token.new(Ked::TokenType::RPAREN, ")"),
        Ked::Token.new(Ked::TokenType::LBRACE, "{"),
        Ked::Token.new(Ked::TokenType::RBRACE, "}"),
        Ked::Token.new(Ked::TokenType::COMMA, ","),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€"),
        Ked::Token.new(Ked::TokenType::EOF, ""),
      ]
      # Create a lexer
      lexer = Ked::Lexer.new input
      # Loop through the array of Tokens and ensure that the correct one is generated in order
      expected.each do |expected_token|
        # Get the next token from the lexer
        lexer_token = lexer.get_next_token
        # Compare both the types and the literals
        lexer_token.token_type.should eq expected_token.token_type
        lexer_token.literal.should eq expected_token.literal
      end
    end

    it "should generate the correct list of tokens when the input is the text of examples/example1.ked" do
      # Generate the input and pass it through the lexer to ensure it works correctly
      filename = "examples/example1.ked"
      input = File.open filename
      # Generate a list of tokens that we expect
      expected = [
        # remember €five = 5 like
        Ked::Token.new(Ked::TokenType::REMEMBER, "remember"),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€"),
        Ked::Token.new(Ked::TokenType::IDENT, "five"),
        Ked::Token.new(Ked::TokenType::ASSIGN, "="),
        Ked::Token.new(Ked::TokenType::NUMBER, "5"),
        Ked::Token.new(Ked::TokenType::LIKE, "like"),
        # remember €ten = 10 like
        Ked::Token.new(Ked::TokenType::REMEMBER, "remember"),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€"),
        Ked::Token.new(Ked::TokenType::IDENT, "ten"),
        Ked::Token.new(Ked::TokenType::ASSIGN, "="),
        Ked::Token.new(Ked::TokenType::NUMBER, "10"),
        Ked::Token.new(Ked::TokenType::LIKE, "like"),
        # bai add (€x, €y) {
        Ked::Token.new(Ked::TokenType::FUNCTION, "bai"),
        Ked::Token.new(Ked::TokenType::IDENT, "add"),
        Ked::Token.new(Ked::TokenType::LPAREN, "("),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€"),
        Ked::Token.new(Ked::TokenType::IDENT, "x"),
        Ked::Token.new(Ked::TokenType::COMMA, ","),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€"),
        Ked::Token.new(Ked::TokenType::IDENT, "y"),
        Ked::Token.new(Ked::TokenType::RPAREN, ")"),
        Ked::Token.new(Ked::TokenType::LBRACE, "{"),
        #     hereYaGoBai €x plus €y like
        Ked::Token.new(Ked::TokenType::RETURN, "hereYaGoBai"),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€"),
        Ked::Token.new(Ked::TokenType::IDENT, "x"),
        Ked::Token.new(Ked::TokenType::ADDITION, "plus"),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€"),
        Ked::Token.new(Ked::TokenType::IDENT, "y"),
        Ked::Token.new(Ked::TokenType::LIKE, "like"),
        # }
        Ked::Token.new(Ked::TokenType::RBRACE, "}"),
        # remember €result = add(€five, €ten) like
        Ked::Token.new(Ked::TokenType::REMEMBER, "remember"),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€"),
        Ked::Token.new(Ked::TokenType::IDENT, "result"),
        Ked::Token.new(Ked::TokenType::ASSIGN, "="),
        Ked::Token.new(Ked::TokenType::IDENT, "add"),
        Ked::Token.new(Ked::TokenType::LPAREN, "("),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€"),
        Ked::Token.new(Ked::TokenType::IDENT, "five"),
        Ked::Token.new(Ked::TokenType::COMMA, ","),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€"),
        Ked::Token.new(Ked::TokenType::IDENT, "ten"),
        Ked::Token.new(Ked::TokenType::RPAREN, ")"),
        Ked::Token.new(Ked::TokenType::LIKE, "like"),
        # EOF
        Ked::Token.new(Ked::TokenType::EOF, ""),
      ]
      # Create a lexer
      lexer = Ked::Lexer.new input
      # Loop through the array of Tokens and ensure that the correct one is generated in order
      expected.each do |expected_token|
        # Get the next token from the lexer
        lexer_token = lexer.get_next_token
        # Compare both the types and the literals
        lexer_token.token_type.should eq expected_token.token_type
        lexer_token.literal.should eq expected_token.literal
      end
    end

    it "should generate the correct list of tokens when the input is the text of examples/example2.ked" do
      # Generate the input and pass it through the lexer to ensure it works correctly
      filename = "examples/example2.ked"
      input = File.open filename
      # Generate a list of tokens that we expect
      expected = [
        # remember €true = gospel like
        Ked::Token.new(Ked::TokenType::REMEMBER, "remember"),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€"),
        Ked::Token.new(Ked::TokenType::IDENT, "true"),
        Ked::Token.new(Ked::TokenType::ASSIGN, "="),
        Ked::Token.new(Ked::TokenType::TRUE, "gospel"),
        Ked::Token.new(Ked::TokenType::LIKE, "like"),
        # remember €false = bull like
        Ked::Token.new(Ked::TokenType::REMEMBER, "remember"),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€"),
        Ked::Token.new(Ked::TokenType::IDENT, "false"),
        Ked::Token.new(Ked::TokenType::ASSIGN, "="),
        Ked::Token.new(Ked::TokenType::FALSE, "bull"),
        Ked::Token.new(Ked::TokenType::LIKE, "like"),
        # eh (€true is bull) {
        Ked::Token.new(Ked::TokenType::IF, "eh"),
        Ked::Token.new(Ked::TokenType::LPAREN, "("),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€"),
        Ked::Token.new(Ked::TokenType::IDENT, "true"),
        Ked::Token.new(Ked::TokenType::EQUALITY, "is"),
        Ked::Token.new(Ked::TokenType::FALSE, "bull"),
        Ked::Token.new(Ked::TokenType::RPAREN, ")"),
        Ked::Token.new(Ked::TokenType::LBRACE, "{"),
        #     remember €x = 2 into 4 like
        Ked::Token.new(Ked::TokenType::REMEMBER, "remember"),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€"),
        Ked::Token.new(Ked::TokenType::IDENT, "x"),
        Ked::Token.new(Ked::TokenType::ASSIGN, "="),
        Ked::Token.new(Ked::TokenType::NUMBER, "2"),
        Ked::Token.new(Ked::TokenType::DIVISION, "into"),
        Ked::Token.new(Ked::TokenType::NUMBER, "4"),
        Ked::Token.new(Ked::TokenType::LIKE, "like"),
        # }
        Ked::Token.new(Ked::TokenType::RBRACE, "}"),
        # orEvenJust {
        Ked::Token.new(Ked::TokenType::ELSE, "orEvenJust"),
        Ked::Token.new(Ked::TokenType::LBRACE, "{"),
        #     remember €x = 2 awayFrom 4 like
        Ked::Token.new(Ked::TokenType::REMEMBER, "remember"),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€"),
        Ked::Token.new(Ked::TokenType::IDENT, "x"),
        Ked::Token.new(Ked::TokenType::ASSIGN, "="),
        Ked::Token.new(Ked::TokenType::NUMBER, "2"),
        Ked::Token.new(Ked::TokenType::SUBTRACTION, "awayFrom"),
        Ked::Token.new(Ked::TokenType::NUMBER, "4"),
        Ked::Token.new(Ked::TokenType::LIKE, "like"),
        # }
        Ked::Token.new(Ked::TokenType::RBRACE, "}"),
        # remember €y = 5 times €x like
        Ked::Token.new(Ked::TokenType::REMEMBER, "remember"),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€"),
        Ked::Token.new(Ked::TokenType::IDENT, "y"),
        Ked::Token.new(Ked::TokenType::ASSIGN, "="),
        Ked::Token.new(Ked::TokenType::NUMBER, "5"),
        Ked::Token.new(Ked::TokenType::MULTIPLICATION, "times"),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€"),
        Ked::Token.new(Ked::TokenType::IDENT, "x"),
        Ked::Token.new(Ked::TokenType::LIKE, "like"),
        # eh (not €y isBiggerThan 10) {
        Ked::Token.new(Ked::TokenType::IF, "eh"),
        Ked::Token.new(Ked::TokenType::LPAREN, "("),
        Ked::Token.new(Ked::TokenType::NEGATION, "not"),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€"),
        Ked::Token.new(Ked::TokenType::IDENT, "y"),
        Ked::Token.new(Ked::TokenType::GT, "isBiggerThan"),
        Ked::Token.new(Ked::TokenType::NUMBER, "10"),
        Ked::Token.new(Ked::TokenType::RPAREN, ")"),
        Ked::Token.new(Ked::TokenType::LBRACE, "{"),
        #     remember €z = 2 like
        Ked::Token.new(Ked::TokenType::REMEMBER, "remember"),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€"),
        Ked::Token.new(Ked::TokenType::IDENT, "z"),
        Ked::Token.new(Ked::TokenType::ASSIGN, "="),
        Ked::Token.new(Ked::TokenType::NUMBER, "2"),
        Ked::Token.new(Ked::TokenType::LIKE, "like"),
        # }
        Ked::Token.new(Ked::TokenType::RBRACE, "}"),
        # eh (€y isSmallerThan 10) {
        Ked::Token.new(Ked::TokenType::IF, "eh"),
        Ked::Token.new(Ked::TokenType::LPAREN, "("),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€"),
        Ked::Token.new(Ked::TokenType::IDENT, "y"),
        Ked::Token.new(Ked::TokenType::LT, "isSmallerThan"),
        Ked::Token.new(Ked::TokenType::NUMBER, "10"),
        Ked::Token.new(Ked::TokenType::RPAREN, ")"),
        Ked::Token.new(Ked::TokenType::LBRACE, "{"),
        #     remember €z = 3 like
        Ked::Token.new(Ked::TokenType::REMEMBER, "remember"),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€"),
        Ked::Token.new(Ked::TokenType::IDENT, "z"),
        Ked::Token.new(Ked::TokenType::ASSIGN, "="),
        Ked::Token.new(Ked::TokenType::NUMBER, "3"),
        Ked::Token.new(Ked::TokenType::LIKE, "like"),
        # }
        Ked::Token.new(Ked::TokenType::RBRACE, "}"),
        # eh (€y isNot 10) {
        Ked::Token.new(Ked::TokenType::IF, "eh"),
        Ked::Token.new(Ked::TokenType::LPAREN, "("),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€"),
        Ked::Token.new(Ked::TokenType::IDENT, "y"),
        Ked::Token.new(Ked::TokenType::INEQUALITY, "isNot"),
        Ked::Token.new(Ked::TokenType::NUMBER, "10"),
        Ked::Token.new(Ked::TokenType::RPAREN, ")"),
        Ked::Token.new(Ked::TokenType::LBRACE, "{"),
        #     remember €z = 3 like
        Ked::Token.new(Ked::TokenType::REMEMBER, "remember"),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€"),
        Ked::Token.new(Ked::TokenType::IDENT, "z"),
        Ked::Token.new(Ked::TokenType::ASSIGN, "="),
        Ked::Token.new(Ked::TokenType::NUMBER, "4"),
        Ked::Token.new(Ked::TokenType::LIKE, "like"),
        # }
        Ked::Token.new(Ked::TokenType::RBRACE, "}"),
        # EOF
        Ked::Token.new(Ked::TokenType::EOF, ""),
      ]
      # Create a lexer
      lexer = Ked::Lexer.new input
      # Loop through the array of Tokens and ensure that the correct one is generated in order
      expected.each do |expected_token|
        # Get the next token from the lexer
        lexer_token = lexer.get_next_token
        # Compare both the types and the literals
        lexer_token.token_type.should eq expected_token.token_type
        lexer_token.literal.should eq expected_token.literal
      end
    end
  end
end
