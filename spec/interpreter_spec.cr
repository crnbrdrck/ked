require "./spec_helper"

describe Ked::Interpreter do
  describe "interpret" do
    it "should be successfully be able to handle an expression of INTEGER PLUS INTEGER and return the correct value" do
      interpreter = Ked::Interpreter.new "3 + 3"
      interpreter.interpret.should eq 6
    end

    it "should be successfully be able to handle an expression of INTEGER MINUS INTEGER and return the correct value" do
      interpreter = Ked::Interpreter.new "7 - 3"
      interpreter.interpret.should eq 4
    end

    it "should be successfully be able to handle an expression of INTEGER MULTIPLY INTEGER and return the correct value" do
      interpreter = Ked::Interpreter.new "7 * 3"
      interpreter.interpret.should eq 21
    end

    it "should be successfully be able to handle an expression of INTEGER DIVIDE INTEGER and return the correct value" do
      interpreter = Ked::Interpreter.new "6 / 3"
      interpreter.interpret.should eq 2
    end

    it "should handle multiple additions and subtractions" do
      interpreter = Ked::Interpreter.new "3 + 3 + 3 - 7"
      interpreter.interpret.should eq 2
    end

    it "should be able to handle complex arithmetic expressions using BEMDAS rule" do
      interpreter = Ked::Interpreter.new "14 + 2 * 3 - 6 / 2"
      interpreter.interpret.should eq 17
    end

    it "should be able to handle complex arithmetic expressions that include brackets" do
      interpreter = Ked::Interpreter.new "3 + (4 * (5 - 2))"
      interpreter.interpret.should eq 15
    end

    it "should throw an error if the expression does match either of these patterns" do
      interpreter = Ked::Interpreter.new "7 x 3"
      expect_raises(Exception) do
        interpreter.interpret
      end
    end
  end
end
