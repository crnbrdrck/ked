module Ked
  # Class for handling the Read-Eval-Print-Loop (REPL) environment for ked
  class REPL
    @@prompt = "\u001b[31mked > \u001b[0m"

    def initialize
      running = true
      while running
        print @@prompt
        input = gets(chomp: true)
        if input
          # Create a lexer and tokenize the given input
          lexer = Ked::Lexer.new input
          # Loop until the end of the text
          while (token = lexer.get_next_token).token_type != TokenType::EOF
            puts token.to_s
          end
        else
          # Take no input to be the end of the REPL loop for now
          running = false
        end
      end
    end
  end
end
