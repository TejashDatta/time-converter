require_relative '../basic_time'

describe 'BasicTime' do
  describe 'initialize and parse_time' do
    let(:expected_hours) { 16 }
    let(:expected_minutes) { 5 }

    context 'when 24H time' do
      let(:basic_time) { BasicTime.new('16:05') }
      
      it 'parses correctly' do
        expect(basic_time.hours).to eq(expected_hours)
        expect(basic_time.minutes).to eq(expected_minutes)
      end
    end

    context 'when 12H time' do
      let(:basic_time) { BasicTime.new('4:05 pm') }

      it 'calculates and parses 24H hours from 12H time correctly' do
        expect(basic_time.hours).to eq(expected_hours)
        expect(basic_time.minutes).to eq(expected_minutes)
      end
    end
  end

  describe '==' do
    it 'compares correctly' do
      expect(BasicTime.new('9:00') == BasicTime.new('9:00')).to be true
    end
  end

  shared_examples 'arithmetic operation' do
    let(:result) { basic_time_1.send(operation, basic_time_2) }

    it 'calculates correctly' do
      expect(result.hours).to eq(expected_result_hours)
      expect(result.minutes).to eq(expected_result_minutes)
    end
  end

  describe '+' do
    let(:operation) { :+ }
    let(:expected_result_hours) { 17 }
    let(:expected_result_minutes) { 0 }

    context 'when first time is in 24H format' do
      let(:basic_time_1) { BasicTime.new('13:00') }
      let(:basic_time_2) { BasicTime.new('4:00') }

      include_examples 'arithmetic operation'
    end

    context 'when first time is in 12H format' do
      let(:basic_time_1) { BasicTime.new('1:00 PM') }
      let(:basic_time_2) { BasicTime.new('4:00') }

      include_examples 'arithmetic operation'
    end 
  end

  describe '-' do
    let(:operation) { :- }
    let(:expected_result_hours) { 9 }
    let(:expected_result_minutes) { 0 }

    context 'when first time is in 24H format' do
      let(:basic_time_1) { BasicTime.new('13:00') }
      let(:basic_time_2) { BasicTime.new('4:00') }

      include_examples 'arithmetic operation'
    end

    context 'when first time is in 12H format' do
      let(:basic_time_1) { BasicTime.new('1:00 PM') }
      let(:basic_time_2) { BasicTime.new('4:00') }

      include_examples 'arithmetic operation'
    end 
  end

  describe 'calculate_carry' do
    let(:carry_calculated_time) { BasicTime.new('-3:90').send(:calculate_carry) }

    it 'ensures hours > 0 and < 24 and minutes > 0 and < 60' do
      expect(carry_calculated_time.hours).to eq(22)
      expect(carry_calculated_time.minutes).to eq(30)
    end
  end

  context 'output and format testing with same time' do
    let(:basic_time) { BasicTime.new('12:00') }

    describe 'to_s' do
      it 'formats as 12H time' do
        expect(basic_time.to_s).to eq('12:00 PM (same day)')
      end
    end

    describe 'format_hours_to_12_hour' do
      it 'converts 24H hours into 12H hours' do
        expect(basic_time.send(:format_hours_to_12_hour)).to eq(12)
      end
    end

    describe 'format_minutes' do
      it 'ensures mintues are double digit' do
        expect(basic_time.send(:format_minutes)).to eq('00')
      end
    end

    describe 'format_am_pm' do
      it 'returns AM or PM based on hours' do
        expect(basic_time.send(:format_am_pm)).to eq('PM')
      end
    end

    describe 'format_day_difference' do
      it 'formats day difference into string explanation' do
        expect(basic_time.send(:format_day_difference)).to eq('same day')
      end
    end
  end
end
