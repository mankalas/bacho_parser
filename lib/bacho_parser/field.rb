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
      raise ParseError, "Invalid #{type} field at position #{position}: '#{data}'" unless valid?(data)

      data
    end

    private

    attr_reader :position, :length, :type, :optional

    def valid?(data)
      case type
      when :number
        regexp = optional ? /\A(\d)*\z/ : /\A(\d)+\z/
        regexp.match?(data)
      when :hexadecimal
        regexp = optional ? /\A(\H)*\z/ : /\A(\H)+\z/
        regexp.match?(data)
      when :packed, :character
        true # No validation rule, always valid is optional
      end
    end
  end
end
