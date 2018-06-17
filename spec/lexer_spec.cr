require "./spec_helper"

describe Ked::Lexer do
  describe "get_next_token" do
    it "should return the EOF token when the text is empty" do
      expected = Ked::Token.new Ked::TokenType::EOF, Ked::TERMINATOR
      Ked::Lexer.new("").get_next_token.should eq expected
    end

    it "should ignore whitespace in the text" do
      expected = Ked::Token.new Ked::TokenType::NUMBER, 3
      Ked::Lexer.new("    3").get_next_token.should eq expected
    end

    it "should return the correct type of token for an NUMBER" do
      expected = Ked::Token.new Ked::TokenType::NUMBER, 3
      Ked::Lexer.new("3").get_next_token.should eq expected
    end

    it "should be able to handle multi digit integers" do
      expected = Ked::Token.new Ked::TokenType::NUMBER, 420
      Ked::Lexer.new("420").get_next_token.should eq expected
    end

    it "should return the correct type of token for addition" do
      expected = Ked::Token.new Ked::TokenType::PLUS, "plus"
      Ked::Lexer.new("plus").get_next_token.should eq expected
    end

    it "should return the correct type of token for subtraction" do
      expected = Ked::Token.new Ked::TokenType::AWAY_FROM, "awayFrom"
      Ked::Lexer.new("awayFrom").get_next_token.should eq expected
    end

    it "should return the correct type of token for multiplication" do
      expected = Ked::Token.new Ked::TokenType::TIMES, "times"
      Ked::Lexer.new("times").get_next_token.should eq expected
    end

    it "should return the correct type of token for division" do
      expected = Ked::Token.new Ked::TokenType::INTO, "into"
      Ked::Lexer.new("into").get_next_token.should eq expected
    end

    it "should return the correct type of token for opening parentheses" do
      expected = Ked::Token.new Ked::TokenType::OPEN_PAREN, '('
      Ked::Lexer.new("(").get_next_token.should eq expected
    end

    it "should return the correct type of token for closing parentheses" do
      expected = Ked::Token.new Ked::TokenType::CLOSE_PAREN, ')'
      Ked::Lexer.new(")").get_next_token.should eq expected
    end

    it "should be able to understand a proper statement and turn it into correct lexemes" do
      text = "remember €x = 2 like"
      lexer = Ked::Lexer.new(text)
      # Tokens in this order: REMEMBER VAR_PREFIX ID ASSIGN NUMBER LIKE
      lexer.get_next_token.should eq Ked::Token.new(Ked::TokenType::REMEMBER, "remember")
      lexer.get_next_token.should eq Ked::Token.new(Ked::TokenType::VAR_PREFIX, '€')
      lexer.get_next_token.should eq Ked::Token.new(Ked::TokenType::ID, "x")
      lexer.get_next_token.should eq Ked::Token.new(Ked::TokenType::ASSIGN, '=')
      lexer.get_next_token.should eq Ked::Token.new(Ked::TokenType::NUMBER, 2)
      lexer.get_next_token.should eq Ked::Token.new(Ked::TokenType::LIKE, "like")
      lexer.get_next_token.should eq Ked::Token.new(Ked::TokenType::EOF, Ked::TERMINATOR)
    end
  end
end
