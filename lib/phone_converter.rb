# frozen_string_literal: true
require_relative 'errors'

module PhoneConverter
  NUMBER_LENGTH = 10
  WORD_MIN_LENGTH = 3

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

      words_pairs = words_pairs_for(number)

      whole_number_words = words_for(number)

      words_pairs = words_pairs.delete_if do |words_pair|
        whole_number_words.include?(words_pair[0] + words_pair[1])
      end

      words_pairs + whole_number_words
    end

    private

    def validate(number)
      raise InvalidNumberError, 'number should contain 10 digits' if number.size < NUMBER_LENGTH
      raise InvalidNumberError, "number shouldn't contain digit '0'" if number.include?('0')
      raise InvalidNumberError, "number shouldn't contain digit '1'" if number.include?('1')
    end

    def word_exists?(suggestion)
      !!@dictionary.bsearch { |word| suggestion.upcase <=> word }
    end

    def all_combinations(number)
      combinations = MAP[number[0]]

      number[1..-1].chars.each do |digit|
        result = []
        combinations.product(MAP[digit]) { |pair| result << pair.join }
        combinations = result
      end

      combinations
    end

    def words_for(number)
      all_combinations(number).select! { |combination| word_exists?(combination) }
    end

    def words_pairs_for(number)
      words = []

      separator_index = WORD_MIN_LENGTH - 1

      while separator_index <= NUMBER_LENGTH - WORD_MIN_LENGTH
        first_subnumber = number[0..separator_index]
        second_subnumber = number[separator_index + 1..NUMBER_LENGTH]
        separator_index += 1

        first_subnumber_words = words_for(first_subnumber)
        next if first_subnumber_words.empty?

        second_subnumber_words = words_for(second_subnumber)
        next if second_subnumber_words.empty?

        words_combinations = first_subnumber_words.product(second_subnumber_words)

        words += words_combinations
      end

      words
    end
  end
end
