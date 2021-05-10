require_relative '../time_converter'
require_relative '../basic_time'

describe 'TimeConverter' do
  let(:test_file_name) { 'spec_test_target.txt' }
  let(:time_converter) { TimeConverter.new(test_file_name, '-5:00', '+5:00') }
  
  describe 'run' do
    let!(:original_contents) { File.read(test_file_name) }
    before { time_converter.run }
    after { File.write(test_file_name, original_contents) }
    
    it 'writes changes in times to file' do
      expect(File.read(test_file_name)).to eq(
        <<~FILE_CONTENT
          Time 12:00 AM (next day) is
          12:00 PM (same day) meet
          at 6:00 AM (next day) till 9:00 AM (next day)
        FILE_CONTENT
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
      expect(time_converter.send(:convert_times, '10:00 18:00 3:15 AM 4:20 PM')).to eq(
        '8:00 PM (same day) 4:00 AM (next day) 1:15 PM (same day) 2:20 AM (next day)'
      )
    end
  end
end
