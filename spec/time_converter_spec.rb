require_relative '../time_converter'
require_relative '../basic_time'

describe 'TimeConverter' do
  let(:test_file_name) { 'spec_test_target.txt' }
  let(:time_converter) { TimeConverter.new(test_file_name, '-5:00', '+5:00') }
  
  describe 'run' do
    let!(:original_contents) { File.read(test_file_name) }
    before { time_converter.run }
    after { File.write(test_file_name, original_contents) }
    
    it 'writes changes in time to file' do
      expect(File.read(test_file_name)).to eq(
        "Time 12:00 AM (next day) is\n12:00 PM (same day) meet\nat 8:00 AM (next day)\n"
      )
    end
  end

  describe 'calculate_offset' do
    it 'calculates offset correctly' do
      expect(time_converter.send('calculate_offset', '-5:00', '+5:00')).to eq(BasicTime.new('10:00'))
    end
  end

  describe 'convert_times' do
    it 'converts all times in string based on offset' do
      expect(time_converter.send(:convert_times, '10:00 18:00')).to eq(
        '8:00 PM (same day) 4:00 AM (next day)'
      )
    end
  end
end
