require "tempfile"

module Ked
  # Null character.
  #
  # Used to mark the end of the input.
  NULL_CHAR = '\u{0}'

  # The Lexer reads in Ked code as its source and generates tokens based on it.
  #
  # The Lexer works as a generator by calling the `#get_next_token` method.
  class Lexer
    @input : Array(String) = [] of String # The lines of the input file that we are parsing
    @filename : String = "<stdin>"        # For string based input, the filename will be <stdin> but this will be replaced by the actual filename when a file is passed
    @line_num : Int32 = 0                 # The current line that we are reading
    @char_num : Int32 = 0                 # Current position in input (points to current char)
    @read_char_num : Int32 = 0            # Current reading position (after current char)
    @current_line : String = ""           # Current line being read
    @current_char : Char = Ked::NULL_CHAR # Current character being examined

    # Create the Lexer by passing in a File descriptor.
    #
    # The File descriptor will be used to generate an array of Strings representing each line of the file, as well as provide a file name to pass to all Token instances.
    def initialize(input : File)
      # Store the name of the file
      @filename = File.basename input.path
      # Get the lines of the file
      @input = File.read_lines input.path
      # Start lexing
      self.read_next_char
    end

    # Create the Lexer using a String that contains Ked source code.
    #
    # The String will be converted into an array of lines, as if it were a File.
    #
    # The filename will be set to "<stdin>" as it is currently assumed that this is the only place that this constructor will be called from.
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

    # Read the next character in the current line of the input.
    #
    # If the end of the current line has been reached, move to the next line.
    #
    # If the end of the input has been reached, set the current_char to be `Ked::NULL_CHARACTER`.
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

    # Skip all whitespace characters or empty lines that are found in the input.
    #
    # Ked uses braces for blocks so whitespace doesn't have much special meaning, so we can just skip them entirely.
    def skip_whitespace_chars
      while @current_char == ' ' || @current_char == '\t' || @current_line == "" || @current_char == '\n' || @current_char == '\r'
        self.read_next_char
      end
    end

    # Generate the next token from the input.
    #
    # First check to see if the current character is a single character token.
    # If not, check if it is a letter or number and try to generate a keyword / identifier or number token respectively.
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

    # Read a word in from the source.
    #
    # The word returned from this method will be checked against `Ked::KEYWORDS` to see if it is a keyword or not.
    #
    # If so, the representative TokenType for that keyword will be used to create the token.
    # If not, a `Ked::TokenType::IDENT` token will be generated with the read word as its value.
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

    # Read a multi-digit number from the source.
    #
    # TODO - Add float handling
    def read_number
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

    # Helper that determines if a character can be used as part of an identifier / keyword.
    #
    # Currently allowed characters are; letters, '_' characters.
    def is_valid_identifier_char?(char : Char)
      char.letter? || char == '_'
    end
  end
end
