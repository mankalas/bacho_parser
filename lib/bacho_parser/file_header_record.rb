require "bacho_parser/record"
require "bacho_parser/field"

require "date"

module BachoParser
  class FileHeaderRecord < Record
    def initialize(line)
      super(line)
    end

    def bank_or_supplier
      field_at(3, 2)
    end

    def branch_or_site
      field_at(5, 4, optional: true)
    end

    def destination_bank
      field_at(9, 2, optional: true)
    end

    def destination_branch
      field_at(11, 4, optional: true)
    end

    def processing_date
      Date.strptime(field_at(21, 8, type: :number), "%d%m%Y")
    end

    def bank_name
      field_at(29, 126, optional: true).strip
    end

    def batchproof_flag
      flag = field_at(158, 1)
      raise ParseError, "Batchproof flag must be 'Y' or 'N' (got '#{flag}')" unless %w[Y N].include?(flag)

      flag
    end

    private

    def check_record_type
      raise ParseError, "Header record doesn't start with 'A' but with '#{line.first}'" if line.first != 'A'
    end

    def field_at(position, length, type: :character, optional: false)
      Field.new(position: position,
                length: length,
                type: type,
                optional: optional).value(line)
    end
  end
end
