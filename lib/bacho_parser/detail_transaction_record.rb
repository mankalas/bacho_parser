require "bacho_parser/record"
require "bacho_parser/field"

module BachoParser
  class DetailTransactionRecord < Record
    def initialize(line)
      super(line)
    end

    def bank
      field_at(3, 2, type: :number)
    end

    def branch
      field_at(5, 4, type: :number)
    end

    def account
      field_at(9, 8, type: :number)
    end

    def suffix
      field_at(17, 4, type: :number)
    end

    def tran_code
      field_at(21, 2, type: :number, optional: true).presence || 0
    end

    def amount
      field_at(27, 11, type: :number)
    end

    def input_source
      field_at(38, 2)
    end

    def eds_centre
      field_at(40, 2, optional: true)
    end

    def originating_bank
      field_at(42, 2, type: :number)
    end

    def originating_branch
      field_at(44, 4, type: :number)
    end

    def batch
      field_at(48, 4, type: :number, optional: true)
    end

    def this_party_name
      field_at(52, 20, optional: true)
    end

    def this_party_reference
      field_at(72, 12, optional: true)
    end

    def this_party_particulars
      field_at(84, 12, optional: true)
    end

    def this_party_analysis
      field_at(96, 12, optional: true)
    end

    def other_party_name
      field_at(108, 20, optional: true)
    end

    def other_party_bank
      field_at(129, 2, type: :number, optional: true)
    end

    def other_party_branch
      field_at(131, 4, type: :number, optional: true)
    end

    def other_party_account
      field_at(135, 8, type: :number, optional: true)
    end

    def other_party_suffix
      field_at(143, 4, type: :number, optional: true)
    end

    def input_date
      field_at(148, 8, type: :date, optional: true)
    end

    def authorisation_code
      field_at(156, 4, type: :packed, optional: true)
    end

    def debit?
      tran_code < 50
    end

    def credit?
      !debit?
    end

    def funds_cleared?
      cleared_funds_indicator == "C"
    end

    private

    def check_record_type
      raise ParseError, "Header record doesn't start with 'A' but with '#{line.first}'" if line.first != 'D'
    end

    def field_at(position, length, type: :character, optional: false)
      Field.new(position: position,
                length: length,
                type: type,
                optional: optional).value(line)
    end

    def cleared_funds_indicator
      field_at(147, 1, optional: true)
    end
  end
end
