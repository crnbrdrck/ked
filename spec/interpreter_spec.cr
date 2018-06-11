require "./spec_helper"

describe Ked::Interpreter do
  describe "error" do
    it "should correctly raise an error" do
      expect_raises(Exception) do
        Ked::Interpreter.new("").error.should
      end
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

    it "should be successfully be able to handle an expression of INTEGER MULTIPLY INTEGER and return the correct value" do
      interpreter = Ked::Interpreter.new "7 * 3"
      interpreter.expr.should eq 21
    end

    it "should be successfully be able to handle an expression of INTEGER DIVIDE INTEGER and return the correct value" do
      interpreter = Ked::Interpreter.new "6 / 3"
      interpreter.expr.should eq 2
    end

    it "should handle multiple additions and subtractions" do
      interpreter = Ked::Interpreter.new "3 + 3 + 3 - 7"
      interpreter.expr.should eq 2
    end

    it "should throw an error if the expression does match either of these patterns" do
      interpreter = Ked::Interpreter.new "7 x 3"
      expect_raises(Exception) do
        interpreter.expr
      end
    end
  end
end
