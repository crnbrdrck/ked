require "./spec_helper"

describe Ked::Token do
  describe "to_s" do
    it "correctly reports the correct type and value for the instance" do
      token = Ked::Token.new Ked::TokenType::INTEGER, 69
      token.to_s.should eq "Token(INTEGER, 69)"
    end
  end

  describe "==" do
    it "should correctly tell that two Tokens are identical" do
      token = Ked::Token.new Ked::TokenType::INTEGER, 69
      other = Ked::Token.new Ked::TokenType::INTEGER, 69
      token.should eq other
    end

    it "should correctly tell that two Tokens are not identical" do
      token = Ked::Token.new Ked::TokenType::INTEGER, 69
      other = Ked::Token.new Ked::TokenType::INTEGER, 70
      (token == other).should be_false
    end
  end
end
