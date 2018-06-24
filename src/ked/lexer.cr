require "tempfile"

module Ked
  # Null character
  NULL_CHAR = '\u{0}'

  # Lexer takes source and generates a list of tokens from it
  # TODO - Lexer should take a File object which enables us to get things like filenames and linenumbers for the Tokens
  # => This should enable us to generate more meaningful errors
  class Lexer
    @input : Array(String) = [] of String # The lines of the input file that we are parsing
    @filename : String = "<stdin>"        # For string based input, the filename will be <stdin> but this will be replaced by the actual filename when a file is passed
    @line_num : Int32 = 0                 # The current line that we are reading
    @char_num : Int32 = 0                 # Current position in input (points to current char)
    @read_char_num : Int32 = 0            # Current reading position (after current char)
    @current_line : String = ""           # Current line being read
    @current_char : Char = Ked::NULL_CHAR # Current character being examined

    # TODO - Change input to be a file and use line / character based positioning instead of char_num in String
    def initialize(input : String)
      # Create a tempfile for the given input so we can read the lines of it
      tempfile = Tempfile.open("stdin", "ked") do |f|
        f.print(input)
      end
      @input = File.read_lines tempfile.path
      # Delete the tempfile
      tempfile.delete
      # Start lexing
      self.read_next_char
    end

    def initialize(input : File)
      # Store the name of the file
      @filename = File.basename input.path
      # Get the lines of the file
      @input = File.read_lines input.path
      # Start lexing
      self.read_next_char
    end

    # Read the next character in the input, checking first to see if we have reached the end of the input
    def read_next_char
      # Need to check if we've reached the end of the current line, and if so move to the next one (if one exists)
      if @read_char_num >= @current_line.size
        # Update the pointers to the correct values
        @line_num += 1
        @char_num = 0
        @read_char_num = 0
        # Check if we've gone past the total number of lines in the file
        if @line_num > @input.size
          @current_line = Ked::NULL_CHAR.to_s # Having it as empty string was making skip_whitespace loop forever
          @current_char = Ked::NULL_CHAR
        else
          @current_line = @input[@line_num - 1]
          @current_char = '\n'
        end
      else
        # Just get the next character of the current line
        @current_char = @current_line[@read_char_num]
        # Update the positions of read_char_num and char_num
        @char_num = @read_char_num
        @read_char_num += 1
      end
    end

    # Skips whitespace characters entirely as they don't mean anything in ked
    def skip_whitespace_chars
      while @current_char == ' ' || @current_char == '\t' || @current_line == "" || @current_char == '\n' || @current_char == '\r'
        self.read_next_char
      end
    end

    # Generate the next token from the input
    def get_next_token : Ked::Token
      # Skip whitespace before reading next token
      self.skip_whitespace_chars
      # Save line and pos number of the start of this token
      # Add 1 to start char since characters start from 1 and not 0
      start_char, start_line = @char_num + 1, @line_num
      token : Ked::Token
      case @current_char
      when '='
        token = Token.new TokenType::ASSIGN, "=", @filename, start_line, start_char
      when '('
        token = Token.new TokenType::LPAREN, "(", @filename, start_line, start_char
      when ')'
        token = Token.new TokenType::RPAREN, ")", @filename, start_line, start_char
      when '{'
        token = Token.new TokenType::LBRACE, "{", @filename, start_line, start_char
      when '}'
        token = Token.new TokenType::RBRACE, "}", @filename, start_line, start_char
      when ','
        token = Token.new TokenType::COMMA, ",", @filename, start_line, start_char
      when '€'
        token = Token.new TokenType::VAR_PREFIX, "€", @filename, start_line, start_char
      when '!'
        # 'not' and '!' are interchangable
        token = Token.new TokenType::NEGATION, "!", @filename, start_line, start_char
      when Ked::NULL_CHAR
        token = Token.new TokenType::EOF, "", @filename, start_line, start_char
      else
        # We need to check if the current character is a letter, and if so try to generate a keyword token for it
        if self.is_valid_identifier_char? @current_char
          value = self.read_identifier
          token_type = Ked::KEYWORDS.fetch value, TokenType::IDENT
          # Early return to avoid the extra call to read_next_char
          return Token.new token_type, value, @filename, start_line, start_char
        elsif @current_char.to_i?
          return Token.new TokenType::NUMBER, self.read_number, @filename, start_line, start_char
        else
          token = Token.new TokenType::ILLEGAL, @current_char.to_s, @filename, start_line, start_char
        end
      end
      # Read the next character and return the created token
      self.read_next_char
      token
    end

    # Method that reads in a series of characters as a potential token value
    def read_identifier
      char_num = @char_num
      # Save the current line and ending character position due to line breaks
      current_line = @current_line
      end_char = @char_num
      while current_line == @current_line && self.is_valid_identifier_char? @current_char
        self.read_next_char
        end_char += 1
      end
      # The identifier is the string between char_num and end_char of the saved line
      current_line[char_num...end_char]
    end

    # Method to read in multi digit numbers
    def read_number
      # TODO - Add float handling
      char_num = @char_num
      # Save the current line and ending character position due to line breaks
      current_line = @current_line
      end_char = @char_num
      while current_line == @current_line && @current_char.to_i?
        self.read_next_char
        end_char += 1
      end
      # The number is the string between char_num and end_char of the saved line
      current_line[char_num...end_char]
    end

    # Helper that checks if the character is a valid character for identifier names
    def is_valid_identifier_char?(char : Char)
      char.letter? || char == '_'
    end
  end
end
