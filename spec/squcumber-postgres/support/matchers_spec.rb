require_relative '../../spec_helper'
require_relative '../../../lib/squcumber-postgres/support/matchers'

module Squcumber
  describe 'MatcherHelpers' do
    let(:dummy_class) { Class.new { include MatcherHelpers } }

    before(:each) do
      allow(Date).to receive(:today).and_return Date.new(2017, 7, 15)
    end

    describe '#convert_mock_values' do
      context 'with day placeholders' do
        it 'sets today' do
          expect(dummy_class.new.convert_mock_value('today')).to eql('2017-07-15')
        end
        it 'sets tomorrow' do
          expect(dummy_class.new.convert_mock_value('tomorrow')).to eql('2017-07-16')
        end
        it 'sets yesterday' do
          expect(dummy_class.new.convert_mock_value('yesterday')).to eql('2017-07-14')
        end
        it 'travels into the past' do
          expect(dummy_class.new.convert_mock_value('10 days ago')).to eql('2017-07-05')
        end
        it 'travels into the future' do
          expect(dummy_class.new.convert_mock_value('30 days from now')).to eql('2017-08-14')
        end
        it 'converts to day' do
          expect(dummy_class.new.convert_mock_value('10 days from now (as day)')).to eql('25')
        end
        it 'converts to month' do
          expect(dummy_class.new.convert_mock_value('30 days from now (as month)')).to eql('8')
        end
        it 'converts to year' do
          expect(dummy_class.new.convert_mock_value('30 days from now (as year)')).to eql('2017')
        end
        it 'sets beginning of day' do
          expect(dummy_class.new.convert_mock_value('beginning of day 10 days from now')).to eql('2017-07-25')
        end
        it 'sets end of day' do
          expect(dummy_class.new.convert_mock_value('end of day 10 days from now')).to eql('2017-07-25')
        end
      end

      context 'with month placeholders' do
        context 'during a leap year' do
          it 'sets last month' do
            allow(Date).to receive(:today).and_return Date.new(2019, 3, 29)
            expect(dummy_class.new.convert_mock_value('last month')).to eql('2019-02-28')
          end
          it 'sets next month' do
            allow(Date).to receive(:today).and_return Date.new(2019, 1, 29)
            expect(dummy_class.new.convert_mock_value('next month')).to eql('2019-02-28')
          end
        end

        context 'when the length of months differ' do
          it 'travels into the past and keeps the day' do
            allow(Date).to receive(:today).and_return Date.new(2019, 3, 31)
            expect(dummy_class.new.convert_mock_value('2 month ago')).to eql('2019-01-31')
          end
          it 'travels into the future and keeps the day' do
            allow(Date).to receive(:today).and_return Date.new(2019, 1, 31)
            expect(dummy_class.new.convert_mock_value('2 months from now')).to eql('2019-03-31')
          end
          it 'sets beginning of month' do
            allow(Date).to receive(:today).and_return Date.new(2019, 1, 31)
            expect(dummy_class.new.convert_mock_value('beginning of month 9 months from now')).to eql('2019-10-01')
          end
          it 'sets end of month' do
            allow(Date).to receive(:today).and_return Date.new(2019, 1, 31)
            expect(dummy_class.new.convert_mock_value('end of month 9 months from now')).to eql('2019-10-31')
          end
        end

        it 'sets last month' do
          expect(dummy_class.new.convert_mock_value('last month')).to eql('2017-06-15')
        end
        it 'sets next month' do
          expect(dummy_class.new.convert_mock_value('next month')).to eql('2017-08-15')
        end
        it 'travels into the past' do
          expect(dummy_class.new.convert_mock_value('10 months ago')).to eql('2016-09-15')
        end
        it 'travels into the future' do
          expect(dummy_class.new.convert_mock_value('10 months from now')).to eql('2018-05-15')
        end
        it 'converts to day' do
          expect(dummy_class.new.convert_mock_value('10 months from now (as day)')).to eql('15')
        end
        it 'converts to month' do
          expect(dummy_class.new.convert_mock_value('10 months from now (as month)')).to eql('5')
        end
        it 'converts to year' do
          expect(dummy_class.new.convert_mock_value('10 months from now (as year)')).to eql('2018')
        end
        it 'sets beginning of month' do
          expect(dummy_class.new.convert_mock_value('beginning of month 10 months from now')).to eql('2018-05-01')
        end
        it 'sets end of month' do
          expect(dummy_class.new.convert_mock_value('end of month 10 months from now')).to eql('2018-05-31')
        end
      end

      context 'with year placeholders' do
        it 'sets last year' do
          expect(dummy_class.new.convert_mock_value('last year')).to eql('2016-07-15')
        end
        it 'sets next year' do
          expect(dummy_class.new.convert_mock_value('next year')).to eql('2018-07-15')
        end
        it 'travels into the past' do
          expect(dummy_class.new.convert_mock_value('10 years ago')).to eql('2007-07-15')
        end
        it 'travels into the future' do
          expect(dummy_class.new.convert_mock_value('10 years from now')).to eql('2027-07-15')
        end
        it 'converts to day' do
          expect(dummy_class.new.convert_mock_value('10 years from now (as day)')).to eql('15')
        end
        it 'converts to month' do
          expect(dummy_class.new.convert_mock_value('10 years from now (as month)')).to eql('7')
        end
        it 'converts to year' do
          expect(dummy_class.new.convert_mock_value('10 years from now (as year)')).to eql('2027')
        end
        it 'sets beginning of year' do
          expect(dummy_class.new.convert_mock_value('beginning of year 10 months from now')).to eql('2018-01-01')
        end
        it 'sets end of year' do
          expect(dummy_class.new.convert_mock_value('end of year 10 months from now')).to eql('2018-12-31')
        end
      end

      context 'with custom format' do
        it 'sets the date format' do
          expect(dummy_class.new.convert_mock_value('today (as custom \'%Y/%m/%d\')')).to eql('2017/07/15')
        end
      end
    end
  end
end
