# frozen_string_literal: true

require 'benchmark'

describe PhoneConverter do
  describe '.convert' do
    context 'number is valid' do
      let(:number) { '6686787825' }

      shared_examples 'converts number correctly' do
        it 'should convert number to correct words' do
          expect(described_class.convert(number)).to match_array(result)
        end

        it 'converts number within 1000ms' do
          expect(Benchmark.realtime do
            described_class.convert(number)
          end).to be < 1
        end
      end

      context 'number is 6686787825' do
        let(:result) do
          [
            %w[motor usual], %w[noun struck], %w[nouns truck],
            %w[nouns usual], %w[onto struck], 'motortruck'
          ]
        end

        include_examples 'converts number correctly'
      end

      context 'number is 2282668687' do
        let(:number) { '2282668687' }
        let(:result) do
          [
            %w[act amounts], %w[act contour], %w[acta mounts],
            %w[bat amounts], %w[bat contour], %w[cat contour], 'catamounts'
          ]
        end

        include_examples 'converts number correctly'
      end
    end

    context 'number is invalid' do
      shared_examples 'invalid number' do
        it 'raises error' do
          expect { described_class.convert(number) }
            .to raise_error(PhoneConverter::InvalidNumberError)
        end
      end

      context 'number contains 0' do
        let(:number) { '2222222220' }

        include_examples 'invalid number'
      end

      context 'number contains 1' do
        let(:number) { '2222222221' }

        include_examples 'invalid number'
      end

      context "number's length less then 10" do
        let(:number) { '22' }

        include_examples 'invalid number'
      end
    end
  end
end
