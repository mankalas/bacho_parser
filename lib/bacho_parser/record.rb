module BachoParser
  class Record
    MAX_LENGTH = 160

    def initialize(line)
      @line = line
      check_line_length
    end

    protected

    attr_reader :line

    private

    attr_writer :header_encountered, :trailer_encountered

    def check_line_length
      raise ParseError, "Line is #{line.length} chars long instead of #{MAX_LENGTH})" unless line.length == MAX_LENGTH
    end

    def check_record_type
      check_trailer_has_not_been_encountered
      t = record_type
      case t
      when :file_header

        header_encountered = true
      when :detail_transaction
        check_header_has_been_encountered

      when :settlement
        check_header_has_been_encountered

      when :file_trailer
        check_header_has_been_encountered

        trailer_encountered = true
      end
    end

    def record_type
      case line.first
      when 'A'
        :file_header
      when 'D'
        :detail_transaction
      when 'S'
        :settlement
      when 'T'
        :file_trailer
      else
        raise ParseError, "Line doesn't start with a valid type (got '#{line.first}', expected one of 'A', 'D', 'S' or 'T')"
      end
    end

    def header_encountered?
      @header_encountered
    end

    def trailer_encountered?
      @trailer_encountered
    end

    def check_header_has_been_encountered
      raise ParseError, "Missing header record" unless header_encountered?
    end

    def check_trailer_has_not_been_encountered
      raise ParseError, "Record after trailer" if trailer_encountered?
    end
  end
end
