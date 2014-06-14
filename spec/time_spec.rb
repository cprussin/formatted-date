require "#{File.dirname(__FILE__)}/../lib/formatted-date/time.rb"

shared_examples_for 'a formatted timekeeping object' do
	before(:each) do
		cls.formats = {
			full: {
				date: '%A, %B %-d, %Y',
				time: '%-I:%M %P',
				glue: 'at'
			},
			noalt: {
				date:         '%A, %B %-d, %Y',
				time:         '%-I:%M %P',
				glue:         'at',
				alternatives: false
			},
			timeonly: {
				time:         '%-I:%M %P',
				alternatives: :time
			},
			dateonly: {
				date:         '%A, %B %-d, %Y',
				alternatives: :date
			}
		}
	end
	let(:time) {cls.new 2014, 06, 11, 1, 0, 0}

	describe '.date_alternative' do
		context 'relative to the next day' do
			let(:other) {Date.new 2014, 06, 12}
			it {expect(time.date_alternative other).to eq 'Yesterday'}
		end

		context 'relative to the same day' do
			let(:other) {Date.new 2014, 06, 11}
			it {expect(time.date_alternative other).to eq 'Today'}
		end

		context 'relative to the previous day' do
			let(:other) {Date.new 2014, 06, 10}
			it {expect(time.date_alternative other).to eq 'Tomorrow'}
		end

		context 'relative to the other days' do
			let(:other) {Date.new 2014, 06, 9}
			it {expect(time.date_alternative other).to be_nil}
		end
	end

	describe '.time_alternative' do
		context 'at midnight' do
			let(:time) {cls.new 2014, 06, 12, 0, 0, 0}
			it {expect(time.time_alternative).to eq 'Midnight'}
		end

		context 'at noon' do
			let(:time) {cls.new 2014, 06, 12, 12, 0, 0}
			it {expect(time.time_alternative).to eq 'Noon'}
		end

		context 'at other times' do
			it {expect(time.time_alternative).to be_nil}
		end
	end

	describe '.<format name>' do
		it {expect(time.full).to eq 'Wednesday, June 11, 2014 at 1:00 am'}
		it {expect(time.timeonly).to eq '1:00 am'}
		it {expect(time.dateonly).to eq 'Wednesday, June 11, 2014'}

		context 'when on a time with an alternative' do
			let(:time) {cls.new 2014, 06, 11, 0, 0, 0}
			it {expect(time.full).to eq 'Wednesday, June 11, 2014 at Midnight'}
			it {expect(time.timeonly).to eq 'Midnight'}
			it {expect(time.noalt).to eq 'Wednesday, June 11, 2014 at 12:00 am'}
		end

		context 'when on a date with an alternative' do
			let(:time) do
				now = cls.now
				cls.new(now.year, now.month, now.day, 1, 0, 0)
			end
			it {expect(time.full).to eq 'Today at 1:00 am'}
			it {expect(time.dateonly).to eq 'Today'}
			it {expect(time.noalt).not_to start_with 'Today'}
			it {expect(time.noalt).to end_with '1:00 am'}
		end

		context 'when on a date and time with alternatives' do
			let(:time) do
				now = cls.now
				cls.new(now.year, now.month, now.day)
			end
			it {expect(time.full).to eq 'Today at Midnight'}
			it {expect(time.dateonly).to eq 'Today'}
			it {expect(time.timeonly).to eq 'Midnight'}
			it {expect(time.noalt).not_to start_with 'Today'}
			it {expect(time.noalt).not_to end_with 'Midnight'}
		end

		context 'when passing a date' do
			let(:other) {Date.new 2014, 06, 12}
			it {expect(time.full(other)).to eq 'Yesterday at 1:00 am'}
			it {expect(time.dateonly(other)).to eq 'Yesterday'}
			it {expect(time.noalt(other)).to eq 'Wednesday, June 11, 2014 at 1:00 am'}
		end
	end

	describe 'unknown methods' do
		it {expect {time.blabla}.to raise_error NoMethodError}
	end
end

describe DateTime do
	let(:cls) {DateTime}

	it_behaves_like 'a formatted timekeeping object'
end

describe Time do
	let(:cls) {Time}

	it_behaves_like 'a formatted timekeeping object'
end
