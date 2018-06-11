require "./spec_helper"

describe Ked::Parser do
  describe "error" do
    it "should correctly raise an error" do
      expect_raises(Exception) do
        Ked::Parser.new("").error.should
      end
    end
  end

  describe "eat" do
    it "should raise an error when the expected type does not match the current type" do
      parser = Ked::Parser.new ""
      # The current_token starts as a special SOF token
      expect_raises(Exception) do
        parser.eat Ked::TokenType::INTEGER
      end
    end
  end

  describe "expr" do
    it "should be successfully be able to handle an expression of INTEGER ADD INTEGER and return the correct value" do
      parser = Ked::Parser.new "3 + 3"
      parser.expr.should eq 6
    end

    it "should be successfully be able to handle an expression of INTEGER SUBTRACT INTEGER and return the correct value" do
      parser = Ked::Parser.new "7 - 3"
      parser.expr.should eq 4
    end

    it "should be successfully be able to handle an expression of INTEGER MULTIPLY INTEGER and return the correct value" do
      parser = Ked::Parser.new "7 * 3"
      parser.expr.should eq 21
    end

    it "should be successfully be able to handle an expression of INTEGER DIVIDE INTEGER and return the correct value" do
      parser = Ked::Parser.new "6 / 3"
      parser.expr.should eq 2
    end

    it "should handle multiple additions and subtractions" do
      parser = Ked::Parser.new "3 + 3 + 3 - 7"
      parser.expr.should eq 2
    end

    it "should be able to handle complex arithmetic expressions using BEMDAS rule" do
      parser = Ked::Parser.new "14 + 2 * 3 - 6 / 2"
      parser.expr.should eq 17
    end

    it "should be able to handle complex arithmetic expressions that include brackets" do
      parser = Ked::Parser.new "3 + (4 * (5 - 2))"
      parser.expr.should eq 15
    end

    it "should throw an error if the expression does match either of these patterns" do
      parser = Ked::Parser.new "7 x 3"
      expect_raises(Exception) do
        parser.expr
      end
    end
  end
end
