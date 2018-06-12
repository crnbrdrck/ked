require "./spec_helper"

describe Ked::Lexer do
  describe "get_next_token" do
    it "should return the EOF token when the text is empty" do
      expected = Ked::Token.new Ked::TokenType::EOF, Ked::TERMINATOR
      Ked::Lexer.new("").get_next_token.should eq expected
    end

    it "should ignore whitespace in the text" do
      expected = Ked::Token.new Ked::TokenType::INTEGER, 3
      Ked::Lexer.new("    3").get_next_token.should eq expected
    end

    it "should return the correct type of token for an INTEGER" do
      expected = Ked::Token.new Ked::TokenType::INTEGER, 3
      Ked::Lexer.new("3").get_next_token.should eq expected
    end

    it "should be able to handle multi digit integers" do
      expected = Ked::Token.new Ked::TokenType::INTEGER, 420
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
  end
end
