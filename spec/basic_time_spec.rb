require_relative '../basic_time'

describe 'BasicTime' do
  describe '==' do
    it 'compares correctly' do
      expect(BasicTime.new('9:00') == BasicTime.new('9:00')).to be true
    end
  end

  describe '+ and -' do
    shared_examples 'arithmetic operation tests' do
      it 'adds correctly' do
        expect(basic_time_1 + basic_time_2).to eq(BasicTime.new('17:00'))
      end

      it 'subtracts correctly' do
        expect(basic_time_1 - basic_time_2).to eq(BasicTime.new('9:00'))
      end
    end

    context 'when first time is in 24H format' do
      let(:basic_time_1) { BasicTime.new('13:00') }
      let(:basic_time_2) { BasicTime.new('4:00') }

      include_examples 'arithmetic operation tests'
    end

    context 'when first time is in 12H format' do
      let(:basic_time_1) { BasicTime.new('1:00 PM') }
      let(:basic_time_2) { BasicTime.new('4:00') }

      include_examples 'arithmetic operation tests'
    end
  end

  describe 'calculate_carry' do
    let(:basic_time) { BasicTime.new('-3:90') }

    it 'ensures hours > 0 and < 24 and minutes > 0 and < 60' do
      expect(basic_time.send(:calculate_carry)).to eq(BasicTime.new('22:30'))
    end
  end

  context 'uses same time' do
    let(:basic_time) { BasicTime.new('14:00') }

    describe 'to_s' do
      it 'formats as 12H time' do
        expect(basic_time.to_s).to eq('2:00 PM (same day)')
      end
    end

    describe 'format_day_carry' do
      it 'formats day difference into string explanation' do
        expect(basic_time.send(:format_day_carry)).to eq('same day')
      end
    end
  end
end
