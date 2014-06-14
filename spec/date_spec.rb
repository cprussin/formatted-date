require "#{File.dirname(__FILE__)}/../lib/formatted-date/date.rb"

describe Date do
	before(:each) do
		Date.formats = {
			normal: '%A, %B %-d, %Y',
			noalt: {
				format:       '%A, %B %-d, %Y',
				alternatives: false
			},
		}
	end
	let(:date) {Date.new 2014, 06, 11}

	describe '.alternative' do
		context 'relative to the next day' do
			let(:other) {Date.new 2014, 06, 12}
			it {expect(date.alternative other).to eq 'Yesterday'}
		end

		context 'relative to the same day' do
			let(:other) {Date.new 2014, 06, 11}
			it {expect(date.alternative other).to eq 'Today'}
		end

		context 'relative to the previous day' do
			let(:other) {Date.new 2014, 06, 10}
			it {expect(date.alternative other).to eq 'Tomorrow'}
		end

		context 'relative to the other days' do
			let(:other) {Date.new 2014, 06, 9}
			it {expect(date.alternative other).to be_nil}
		end
	end

	describe '.<format name>' do
		it {expect(date.normal).to eq 'Wednesday, June 11, 2014'}
		it {expect(date.noalt).to eq 'Wednesday, June 11, 2014'}

		context 'when on a date with an alternative' do
			let(:date) do
				now = Time.now
				Date.new(now.year, now.month, now.day)
			end
			it {expect(date.normal).to eq 'Today'}
			it {expect(date.noalt).not_to eq 'Today'}
		end

		context 'when passing a date' do
			let(:other) {Date.new 2014, 06, 12}
			it {expect(date.normal(other)).to eq 'Yesterday'}
			it {expect(date.noalt(other)).to eq 'Wednesday, June 11, 2014'}
		end
	end
end
