require "date"

module BachoParser
  class Field
    def initialize(position:, length:, type: :character, optional: false)
      @position = position
      @length = length
      @type = type
      @optional = optional
    end

    def value(line)
      data = line.slice(position, length)
      raise ParseError, "Missing required field" if missing_data?(data)

      raise ParseError, "Invalid #{type} field at position #{position}: '#{data}'" unless valid?(data)

      type_data(data)
    end

    private

    attr_reader :position, :length, :type, :optional

    def valid?(data)
      case type
      when :number
        /\A(\d)+\z/.match?(data)
      when :hexadecimal
        /\A(\H)+\z/.match?(data)
      when :date
        begin
          date = to_date(data)
          Date.valid_date?(date.year, date.month, date.day)
        rescue ArgumentError
          false
        end
      when :packed, :character
        true # No validation rule
      end
    end

    def type_data(data)
      case type
      when :number
        Integer(data)
      when :date
        to_date(data)
      else
        data
      end
    end

    def missing_data?(data)
      !optional && data.strip.empty?
    end

    def to_date(data)
      Date.strptime(data, "%d%m%Y")
    end
  end
end
