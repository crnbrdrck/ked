require "./spec_helper"

describe Ked do
  describe "Interpreter Global State" do
    it "should contain the correct information after parsing the examples/example1.ked script" do
      # Now generate expected data and check that it is correctly generated
      expected = {
        "a"      => 2,
        "x"      => 11,
        "c"      => 27,
        "b"      => 25,
        "number" => 2,
      }
      text = File.read "examples/example1.ked"
      puts "\nContents of example1.ked:\n#{text}"
      # Create an interpreter to interpret the text
      interpreter = Ked::Interpreter.new text
      interpreter.interpret
      interpreter.global_scope.should eq expected
    end
  end
end
