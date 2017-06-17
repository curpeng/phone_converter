# frozen_string_literal: true

require_relative 'errors'
require 'pry'

module PhoneConverter
  NUMBER_LENGTH = 10

  MAP = {
    '2' => %w[a b c],
    '3' => %w[d e f],
    '4' => %w[g h i],
    '5' => %w[j k l],
    '6' => %w[m n o],
    '7' => %w[p q r s],
    '8' => %w[t u v],
    '9' => %w[w x y z]
  }.freeze

  @dictionary = File.readlines(File.dirname(__FILE__) + '/dictionary.txt').map(&:strip)

  class << self
    def convert(number)
      number = number.to_s
      validate(number)

      dictionary = @dictionary.dup

      number.chars.each_with_index do |digit, index|
        appropriate_chars = MAP[digit].map(&:upcase)
        dictionary = dictionary.select { |word| appropriate_chars.include?(word[index]) }
      end

      dictionary
    end

    private

    def validate(number)
      raise InvalidNumberError, 'number should contain 10 digits' if number.size < NUMBER_LENGTH
      raise InvalidNumberError, "number shouldn't contain digit '0'" if number.include?('0')
      raise InvalidNumberError, "number shouldn't contain digit '1'" if number.include?('1')
    end
  end
end
