require "./spec_helper"

describe Ked::Lexer do
  describe "get_next_token" do
    it "should generate the correct list of tokens given the input `=+(){},€` (all single character tokens in ked)" do
      # Generate the input and pass it through the lexer to ensure it works correctly
      input = "=(){},€"
      # Generate a list of tokens that we expect
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
      input = File.read "../examples/example1.ked"
      # Generate a list of tokens that we expect
      expected = [
        Token.new(TokenType::REMEMBER, "remember"),
        Token.new(TokenType::VAR_PREFIX, "€"),
        Token.new(TokenType::IDENT, "five"),
        Token.new(TokenType::ASSIGN, "="),
        Token.new(TokenType::NUMBER, "5"),
        Token.new(TokenType::LIKE, "like"),
        Token.new(TokenType::REMEMBER, "remember"),
        Token.new(TokenType::VAR_PREFIX, "€"),
        Token.new(TokenType::IDENT, "ten"),
        Token.new(TokenType::ASSIGN, "="),
        Token.new(TokenType::LIKE, "like"),
        Token.new(TokenType::FUNCTION, "bai"),
        Token.new(TokenType::IDENT, "add"),
        Token.new(TokenType::LPAREN, "("),
        Token.new(TokenType::VAR_PREFIX, "€"),
        Token.new(TokenType::IDENT, "x"),
        Token.new(TokenType::COMMA, ","),
        Token.new(TokenType::VAR_PREFIX, "€"),
        Token.new(TokenType::IDENT, "y"),
        Token.new(TokenType::LBRACE, "{"),
        Token.new(TokenType::RETURN, "hereYaGoBai"),
        Token.new(TokenType::VAR_PREFIX, "€"),
        Token.new(TokenType::IDENT, "x"),
        Token.new(TokenType::ADDITION, "plus"),
        Token.new(TokenType::VAR_PREFIX, "€"),
        Token.new(TokenType::IDENT, "y"),
        Token.new(TokenType::LIKE, "like"),
        Token.new(TokenType::RBRACE, "}"),
        Token.new(TokenType::REMEMBER, "remember"),
        Token.new(TokenType::VAR_PREFIX, "€"),
        Token.new(TokenType::IDENT, "result"),
        Token.new(TokenType::ASSIGN, "="),
        Token.new(TokenType::IDENT, "add"),
        Token.new(TokenType::LPAREN, "("),
        Token.new(TokenType::VAR_PREFIX, "€"),
        Token.new(TokenType::IDENT, "five"),
        Token.new(TokenType::COMMA, ","),
        Token.new(TokenType::VAR_PREFIX, "€"),
        Token.new(TokenType::IDENT, "ten"),
        Token.new(TokenType::RPAREN, ")"),
        Token.new(TokenType::LIKE, "like"),
        Token.new(TokenType::EOF, ""),
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
