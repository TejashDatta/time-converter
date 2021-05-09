require_relative '../simple_time'

describe 'SimpleTime' do
  context 'artihmetic operations' do
    let(:simple_time_1) { SimpleTime.new('10:00') }
    let(:simple_time_2) { SimpleTime.new('4:00') }

    describe '+' do
      it 'adds correctly' do
        expect(simple_time_1 + simple_time_2).to eq(SimpleTime.new('14:00'))
      end
    end

    describe '-' do
      it 'subtracts correctly' do
        expect(simple_time_1 - simple_time_2).to eq(SimpleTime.new('6:00'))
      end
    end
  end

  

  describe 'calculate_carry' do
    let(:simple_time) { SimpleTime.new('-3:90') }

    it 'ensures hours > 0 and < 24 and minutes > 0 and < 60' do
      expect(simple_time.send(:calculate_carry)).to eq(SimpleTime.new('22:30'))
    end
  end

  context 'uses normal time' do
    let(:simple_time) { SimpleTime.new('10:00') }

    describe 'to_s' do
      it 'formats as time' do
        expect(simple_time.to_s).to eq('10:00 (same day)')
      end
    end

    describe 'format_day_carry' do
      it 'formats day difference into string explanation' do
        expect(simple_time.send(:format_day_carry)).to eq('same day')
      end
    end
  end

  
end
