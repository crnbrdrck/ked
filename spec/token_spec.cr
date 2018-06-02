require "./spec_helper"

describe Ked::Token do
  describe "to_s" do
    it "correctly reports the correct type and value for the instance" do
      token = Ked::Token.new Ked::TokenType::INTEGER, 69
      token.to_s.should eq "Token(INTEGER, 69)"
    end
  end
end
