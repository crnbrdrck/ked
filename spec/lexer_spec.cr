require "./spec_helper"

describe Ked::Lexer do
  describe "get_next_token" do
    it "should generate the correct list of tokens given the input `=+(){},€` (all single character tokens in ked)" do
      # Generate the input and pass it through the lexer to ensure it works correctly
      input = "=(){},€"
      # Generate a list of tokens that we expect
      filename = "<stdin>"
      expected = [
        Ked::Token.new(Ked::TokenType::ASSIGN, "=", filename, 1, 1),
        Ked::Token.new(Ked::TokenType::LPAREN, "(", filename, 1, 2),
        Ked::Token.new(Ked::TokenType::RPAREN, ")", filename, 1, 3),
        Ked::Token.new(Ked::TokenType::LBRACE, "{", filename, 1, 4),
        Ked::Token.new(Ked::TokenType::RBRACE, "}", filename, 1, 5),
        Ked::Token.new(Ked::TokenType::COMMA, ",", filename, 1, 6),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€", filename, 1, 7),
        Ked::Token.new(Ked::TokenType::EOF, "", filename, 2, 1),
      ]
      # Create a lexer
      lexer = Ked::Lexer.new input
      # Loop through the array of Tokens and ensure that the correct one is generated in order
      expected.each do |expected_token|
        # Get the next token from the lexer
        lexer_token = lexer.get_next_token
        # Compare the two tokens using their `to_s` methods
        lexer_token.to_s.should eq expected_token.to_s
      end
    end

    it "should generate the correct list of tokens when the input is the text of examples/example1.ked" do
      # Generate the input and pass it through the lexer to ensure it works correctly
      filename = "examples/example1.ked"
      input = File.open filename
      # Generate a list of tokens that we expect
      expected = [
        # remember €five = 5 like
        Ked::Token.new(Ked::TokenType::REMEMBER, "remember", filename, 1, 1),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€", filename, 1, 10),
        Ked::Token.new(Ked::TokenType::IDENT, "five", filename, 1, 11),
        Ked::Token.new(Ked::TokenType::ASSIGN, "=", filename, 1, 16),
        Ked::Token.new(Ked::TokenType::NUMBER, "5", filename, 1, 18),
        Ked::Token.new(Ked::TokenType::LIKE, "like", filename, 1, 20),
        # remember €ten = 10 like
        Ked::Token.new(Ked::TokenType::REMEMBER, "remember", filename, 2, 1),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€", filename, 2, 10),
        Ked::Token.new(Ked::TokenType::IDENT, "ten", filename, 2, 11),
        Ked::Token.new(Ked::TokenType::ASSIGN, "=", filename, 2, 15),
        Ked::Token.new(Ked::TokenType::NUMBER, "10", filename, 2, 17),
        Ked::Token.new(Ked::TokenType::LIKE, "like", filename, 2, 20),
        # bai add (€x, €y) {
        Ked::Token.new(Ked::TokenType::FUNCTION, "bai", filename, 4, 1),
        Ked::Token.new(Ked::TokenType::IDENT, "add", filename, 4, 5),
        Ked::Token.new(Ked::TokenType::LPAREN, "(", filename, 4, 9),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€", filename, 4, 10),
        Ked::Token.new(Ked::TokenType::IDENT, "x", filename, 4, 11),
        Ked::Token.new(Ked::TokenType::COMMA, ",", filename, 4, 12),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€", filename, 4, 14),
        Ked::Token.new(Ked::TokenType::IDENT, "y", filename, 4, 15),
        Ked::Token.new(Ked::TokenType::RPAREN, ")", filename, 4, 16),
        Ked::Token.new(Ked::TokenType::LBRACE, "{", filename, 4, 18),
        #     hereYaGoBai €x plus €y like
        Ked::Token.new(Ked::TokenType::RETURN, "hereYaGoBai", filename, 5, 5),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€", filename, 5, 17),
        Ked::Token.new(Ked::TokenType::IDENT, "x", filename, 5, 18),
        Ked::Token.new(Ked::TokenType::ADDITION, "plus", filename, 5, 20),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€", filename, 5, 25),
        Ked::Token.new(Ked::TokenType::IDENT, "y", filename, 5, 26),
        Ked::Token.new(Ked::TokenType::LIKE, "like", filename, 5, 28),
        # }
        Ked::Token.new(Ked::TokenType::RBRACE, "}", filename, 6, 1),
        # remember €result = add(€five, €ten) like
        Ked::Token.new(Ked::TokenType::REMEMBER, "remember", filename, 8, 1),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€", filename, 8, 10),
        Ked::Token.new(Ked::TokenType::IDENT, "result", filename, 8, 11),
        Ked::Token.new(Ked::TokenType::ASSIGN, "=", filename, 8, 18),
        Ked::Token.new(Ked::TokenType::IDENT, "add", filename, 8, 20),
        Ked::Token.new(Ked::TokenType::LPAREN, "(", filename, 8, 23),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€", filename, 8, 24),
        Ked::Token.new(Ked::TokenType::IDENT, "five", filename, 8, 25),
        Ked::Token.new(Ked::TokenType::COMMA, ",", filename, 8, 29),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€", filename, 8, 31),
        Ked::Token.new(Ked::TokenType::IDENT, "ten", filename, 8, 32),
        Ked::Token.new(Ked::TokenType::RPAREN, ")", filename, 8, 35),
        Ked::Token.new(Ked::TokenType::LIKE, "like", filename, 8, 37),
        # EOF
        Ked::Token.new(Ked::TokenType::EOF, "", filename, 9, 1),
      ]
      # Create a lexer
      lexer = Ked::Lexer.new input
      # Loop through the array of Tokens and ensure that the correct one is generated in order
      expected.each do |expected_token|
        # Get the next token from the lexer
        lexer_token = lexer.get_next_token
        # Compare the two tokens using their `to_s` methods
        lexer_token.to_s.should eq expected_token.to_s
      end
    end

    it "should generate the correct list of tokens when the input is the text of examples/example2.ked" do
      # Generate the input and pass it through the lexer to ensure it works correctly
      filename = "examples/example2.ked"
      input = File.open filename
      # Generate a list of tokens that we expect
      expected = [
        # remember €true = gospel like
        Ked::Token.new(Ked::TokenType::REMEMBER, "remember", filename, 1, 1),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€", filename, 1, 10),
        Ked::Token.new(Ked::TokenType::IDENT, "true", filename, 1, 11),
        Ked::Token.new(Ked::TokenType::ASSIGN, "=", filename, 1, 16),
        Ked::Token.new(Ked::TokenType::TRUE, "gospel", filename, 1, 18),
        Ked::Token.new(Ked::TokenType::LIKE, "like", filename, 1, 25),
        # remember €false = bull like
        Ked::Token.new(Ked::TokenType::REMEMBER, "remember", filename, 2, 1),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€", filename, 2, 10),
        Ked::Token.new(Ked::TokenType::IDENT, "false", filename, 2, 11),
        Ked::Token.new(Ked::TokenType::ASSIGN, "=", filename, 2, 17),
        Ked::Token.new(Ked::TokenType::FALSE, "bull", filename, 2, 19),
        Ked::Token.new(Ked::TokenType::LIKE, "like", filename, 2, 24),
        # eh (€true is bull) {
        Ked::Token.new(Ked::TokenType::IF, "eh", filename, 3, 1),
        Ked::Token.new(Ked::TokenType::LPAREN, "(", filename, 3, 4),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€", filename, 3, 5),
        Ked::Token.new(Ked::TokenType::IDENT, "true", filename, 3, 6),
        Ked::Token.new(Ked::TokenType::EQUALITY, "is", filename, 3, 11),
        Ked::Token.new(Ked::TokenType::FALSE, "bull", filename, 3, 14),
        Ked::Token.new(Ked::TokenType::RPAREN, ")", filename, 3, 18),
        Ked::Token.new(Ked::TokenType::LBRACE, "{", filename, 3, 20),
        #     remember €x = 2 into 4 like
        Ked::Token.new(Ked::TokenType::REMEMBER, "remember", filename, 4, 5),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€", filename, 4, 14),
        Ked::Token.new(Ked::TokenType::IDENT, "x", filename, 4, 15),
        Ked::Token.new(Ked::TokenType::ASSIGN, "=", filename, 4, 17),
        Ked::Token.new(Ked::TokenType::NUMBER, "2", filename, 4, 19),
        Ked::Token.new(Ked::TokenType::DIVISION, "into", filename, 4, 21),
        Ked::Token.new(Ked::TokenType::NUMBER, "4", filename, 4, 26),
        Ked::Token.new(Ked::TokenType::LIKE, "like", filename, 4, 28),
        # }
        Ked::Token.new(Ked::TokenType::RBRACE, "}", filename, 5, 1),
        # orEvenJust {
        Ked::Token.new(Ked::TokenType::ELSE, "orEvenJust", filename, 6, 1),
        Ked::Token.new(Ked::TokenType::LBRACE, "{", filename, 6, 12),
        #     remember €x = 2 awayFrom 4 like
        Ked::Token.new(Ked::TokenType::REMEMBER, "remember", filename, 7, 5),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€", filename, 7, 14),
        Ked::Token.new(Ked::TokenType::IDENT, "x", filename, 7, 15),
        Ked::Token.new(Ked::TokenType::ASSIGN, "=", filename, 7, 17),
        Ked::Token.new(Ked::TokenType::NUMBER, "2", filename, 7, 19),
        Ked::Token.new(Ked::TokenType::SUBTRACTION, "awayFrom", filename, 7, 21),
        Ked::Token.new(Ked::TokenType::NUMBER, "4", filename, 7, 30),
        Ked::Token.new(Ked::TokenType::LIKE, "like", filename, 7, 32),
        # }
        Ked::Token.new(Ked::TokenType::RBRACE, "}", filename, 8, 1),
        # remember €y = 5 times €x like
        Ked::Token.new(Ked::TokenType::REMEMBER, "remember", filename, 9, 1),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€", filename, 9, 10),
        Ked::Token.new(Ked::TokenType::IDENT, "y", filename, 9, 11),
        Ked::Token.new(Ked::TokenType::ASSIGN, "=", filename, 9, 13),
        Ked::Token.new(Ked::TokenType::NUMBER, "5", filename, 9, 15),
        Ked::Token.new(Ked::TokenType::MULTIPLICATION, "times", filename, 9, 17),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€", filename, 9, 23),
        Ked::Token.new(Ked::TokenType::IDENT, "x", filename, 9, 24),
        Ked::Token.new(Ked::TokenType::LIKE, "like", filename, 9, 26),
        # eh (not €y isBiggerThan 10) {
        Ked::Token.new(Ked::TokenType::IF, "eh", filename, 11, 1),
        Ked::Token.new(Ked::TokenType::LPAREN, "(", filename, 11, 4),
        Ked::Token.new(Ked::TokenType::NEGATION, "not", filename, 11, 5),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€", filename, 11, 9),
        Ked::Token.new(Ked::TokenType::IDENT, "y", filename, 11, 10),
        Ked::Token.new(Ked::TokenType::GT, "isBiggerThan", filename, 11, 12),
        Ked::Token.new(Ked::TokenType::NUMBER, "10", filename, 11, 25),
        Ked::Token.new(Ked::TokenType::RPAREN, ")", filename, 11, 27),
        Ked::Token.new(Ked::TokenType::LBRACE, "{", filename, 11, 29),
        #     remember €z = 2 like
        Ked::Token.new(Ked::TokenType::REMEMBER, "remember", filename, 12, 5),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€", filename, 12, 14),
        Ked::Token.new(Ked::TokenType::IDENT, "z", filename, 12, 15),
        Ked::Token.new(Ked::TokenType::ASSIGN, "=", filename, 12, 17),
        Ked::Token.new(Ked::TokenType::NUMBER, "2", filename, 12, 19),
        Ked::Token.new(Ked::TokenType::LIKE, "like", filename, 12, 21),
        # }
        Ked::Token.new(Ked::TokenType::RBRACE, "}", filename, 13, 1),
        # eh (€y isSmallerThan 10) {
        Ked::Token.new(Ked::TokenType::IF, "eh", filename, 14, 1),
        Ked::Token.new(Ked::TokenType::LPAREN, "(", filename, 14, 4),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€", filename, 14, 5),
        Ked::Token.new(Ked::TokenType::IDENT, "y", filename, 14, 6),
        Ked::Token.new(Ked::TokenType::LT, "isSmallerThan", filename, 14, 8),
        Ked::Token.new(Ked::TokenType::NUMBER, "10", filename, 14, 22),
        Ked::Token.new(Ked::TokenType::RPAREN, ")", filename, 14, 24),
        Ked::Token.new(Ked::TokenType::LBRACE, "{", filename, 14, 26),
        #     remember €z = 3 like
        Ked::Token.new(Ked::TokenType::REMEMBER, "remember", filename, 15, 5),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€", filename, 15, 14),
        Ked::Token.new(Ked::TokenType::IDENT, "z", filename, 15, 15),
        Ked::Token.new(Ked::TokenType::ASSIGN, "=", filename, 15, 17),
        Ked::Token.new(Ked::TokenType::NUMBER, "3", filename, 15, 19),
        Ked::Token.new(Ked::TokenType::LIKE, "like", filename, 15, 21),
        # }
        Ked::Token.new(Ked::TokenType::RBRACE, "}", filename, 16, 1),
        # eh (€y isNot 10) {
        Ked::Token.new(Ked::TokenType::IF, "eh", filename, 17, 1),
        Ked::Token.new(Ked::TokenType::LPAREN, "(", filename, 17, 4),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€", filename, 17, 5),
        Ked::Token.new(Ked::TokenType::IDENT, "y", filename, 17, 6),
        Ked::Token.new(Ked::TokenType::INEQUALITY, "isNot", filename, 17, 8),
        Ked::Token.new(Ked::TokenType::NUMBER, "10", filename, 17, 14),
        Ked::Token.new(Ked::TokenType::RPAREN, ")", filename, 17, 16),
        Ked::Token.new(Ked::TokenType::LBRACE, "{", filename, 17, 18),
        #     remember €z = 3 like
        Ked::Token.new(Ked::TokenType::REMEMBER, "remember", filename, 18, 5),
        Ked::Token.new(Ked::TokenType::VAR_PREFIX, "€", filename, 18, 14),
        Ked::Token.new(Ked::TokenType::IDENT, "z", filename, 18, 15),
        Ked::Token.new(Ked::TokenType::ASSIGN, "=", filename, 18, 17),
        Ked::Token.new(Ked::TokenType::NUMBER, "4", filename, 18, 19),
        Ked::Token.new(Ked::TokenType::LIKE, "like", filename, 18, 21),
        # }
        Ked::Token.new(Ked::TokenType::RBRACE, "}", filename, 19, 1),
        # EOF
        Ked::Token.new(Ked::TokenType::EOF, "", filename, 20, 1),
      ]
      # Create a lexer
      lexer = Ked::Lexer.new input
      # Loop through the array of Tokens and ensure that the correct one is generated in order
      expected.each do |expected_token|
        # Get the next token from the lexer
        lexer_token = lexer.get_next_token
        # Compare the two tokens using their `to_s` methods
        lexer_token.to_s.should eq expected_token.to_s
      end
    end
  end
end
