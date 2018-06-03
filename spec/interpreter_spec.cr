require "./spec_helper"

describe Ked::Interpreter do
  describe "error" do
    it "should correctly raise an error" do
      expect_raises(Exception) do
        Ked::Interpreter.new("").error.should
      end
    end
  end

  describe "get_next_token" do
    it "should return the EOF token when the text is empty" do
      expected = Ked::Token.new Ked::TokenType::EOF, '\u{0}'
      Ked::Interpreter.new("").get_next_token.should eq expected
    end

    it "should ignore whitespace in the text" do
      expected = Ked::Token.new Ked::TokenType::INTEGER, 3
      Ked::Interpreter.new("    3").get_next_token.should eq expected
    end

    it "should return the correct type of token for an INTEGER" do
      expected = Ked::Token.new Ked::TokenType::INTEGER, 3
      Ked::Interpreter.new("3").get_next_token.should eq expected
    end

    it "should be able to handle multi digit integers" do
      expected = Ked::Token.new Ked::TokenType::INTEGER, 420
      Ked::Interpreter.new("420").get_next_token.should eq expected
    end

    it "should return the correct type of token for addition" do
      expected = Ked::Token.new Ked::TokenType::PLUS, '+'
      Ked::Interpreter.new("+").get_next_token.should eq expected
    end

    it "should return the correct type of token for subtraction" do
      expected = Ked::Token.new Ked::TokenType::MINUS, '-'
      Ked::Interpreter.new("-").get_next_token.should eq expected
    end
  end

  describe "eat" do
    it "should raise an error when the expected type does not match the current type" do
      interpreter = Ked::Interpreter.new ""
      # The current_token starts as a special SOF token
      expect_raises(Exception) do
        interpreter.eat Ked::TokenType::INTEGER
      end
    end
  end

  describe "expr" do
    it "should be successfully be able to handle an expression of INTEGER PLUS INTEGER and return the correct value" do
      interpreter = Ked::Interpreter.new "3 + 3"
      interpreter.expr.should eq 6
    end

    it "should be successfully be able to handle an expression of INTEGER MINUS INTEGER and return the correct value" do
      interpreter = Ked::Interpreter.new "7 - 3"
      interpreter.expr.should eq 4
    end

    it "should throw an error if the expression does match either of these patterns" do
      interpreter = Ked::Interpreter.new "7 * 3"
      expect_raises(Exception) do
        interpreter.expr
      end
    end
  end
end
