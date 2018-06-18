require "./spec_helper"

describe Ked do
  describe "Interpreter Global Scope" do
    it "should contain the correct information after parsing the examples/example1.ked script" do
      # Now generate expected data and check that it is correctly generated
      expected = {
        "a"      => 2,
        "b"      => 25,
        "c"      => 27,
        "number" => 2,
        "x"      => 11,
      }
      text = File.read "examples/example1.ked"
      puts "\nContents of example1.ked:\n#{text}"
      # Create an interpreter to interpret the text
      interpreter = Ked::Interpreter.new text
      interpreter.interpret
      interpreter.global_scope.should eq expected
    end

    it "should contain the correct information after parsing the examples/example2.ked script" do
      # Now generate expected data and check that it is correctly generated
      expected = {
        "a"      => 2,
        "b"      => 25,
        "c"      => 27,
        "number" => 2,
        "x"      => 11,
        "y"      => (20.0 / 7) + 3.14,
      }
      text = File.read "examples/example2.ked"
      puts "\nContents of example2.ked:\n#{text}"
      # Create an interpreter to interpret the text
      interpreter = Ked::Interpreter.new text
      interpreter.interpret
      interpreter.global_scope.should eq expected
    end

    it "should contain the correct information after parsing the examples/example3.ked script" do
      # Now generate expected data and check that it is correctly generated
      expected = {"num2" => 4}
      text = File.read "examples/example3.ked"
      puts "\nContents of example3.ked:\n#{text}"
      # Create an interpreter to interpret the text
      interpreter = Ked::Interpreter.new text
      interpreter.interpret
      interpreter.global_scope.should eq expected
    end

    it "should generate an error when attempting to interpret the examples/bad_example.ked script" do
      # Now generate expected data and check that it is correctly generated
      text = File.read "examples/bad_example.ked"
      puts "\nContents of bad_example.ked:\n#{text}"
      # Create an interpreter to interpret the text
      interpreter = Ked::Interpreter.new text
      expect_raises(Exception) do
        interpreter.interpret
      end
    end
  end
end
