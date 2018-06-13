require "./spec_helper"

describe Ked::Interpreter do
  describe "interpret" do
    it "should be successfully be able to handle an expression of INTEGER PLUS INTEGER and return the correct value" do
      interpreter = Ked::Interpreter.new "remember €x = 3 plus 3 like"
      interpreter.interpret
      interpreter.global_scope["x"].should eq 6
    end

    it "should be successfully be able to handle an expression of INTEGER AWAY_FROM INTEGER and return the correct value" do
      interpreter = Ked::Interpreter.new "remember €x = 3 awayFrom 7 like"
      interpreter.interpret
      interpreter.global_scope["x"].should eq 4
    end

    it "should be successfully be able to handle an expression of INTEGER TIMES INTEGER and return the correct value" do
      interpreter = Ked::Interpreter.new "remember €x = 7 times 3 like"
      interpreter.interpret
      interpreter.global_scope["x"].should eq 21
    end

    it "should be successfully be able to handle an expression of INTEGER INTO INTEGER and return the correct value" do
      interpreter = Ked::Interpreter.new "remember €x = 3 into 6 like"
      interpreter.interpret
      interpreter.global_scope["x"].should eq 2
    end

    it "should handle multiple additions and subtractions" do
      interpreter = Ked::Interpreter.new "remember €x = 7 awayFrom 3 plus 3 plus 3 like"
      interpreter.interpret
      interpreter.global_scope["x"].should eq 2
    end

    it "should be able to handle complex arithmetic expressions using BEMDAS rule" do
      interpreter = Ked::Interpreter.new "remember €x = 14 plus (2 into 6 awayFrom 2 times 3) like"
      interpreter.interpret
      interpreter.global_scope["x"].should eq 17
    end

    it "should be able to handle complex arithmetic expressions that include brackets" do
      interpreter = Ked::Interpreter.new "remember €x = 3 plus (4 times (2 awayFrom 5)) like"
      interpreter.interpret
      interpreter.global_scope["x"].should eq 15
    end

    it "should throw an error if an assignment statement is empty" do
      interpreter = Ked::Interpreter.new "remember like"
      expect_raises(Exception) do
        interpreter.interpret
      end
    end
  end
end
