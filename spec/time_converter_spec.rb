require_relative '../time_converter'
require_relative '../basic_time'

describe 'TimeConverter' do
  let(:time_converter) { TimeConverter.new }
  let(:usage) {
    <<~USAGE
      <source-file> <source-timezone> <destination-timezone>
      Description: converts times in file in 12 hour or 24 hour format into times of the destination timezone in 12 hour format
      
      source-file: file with times
      source-timezone: timezone of times in source file
      destination-timezone: timezone you wish to convert all times to
    USAGE
  }
  let(:test_file_name) { 'spec_test_target.txt' }
  let(:test_file_content) { 
    <<~CONTENT
      Time 14:00 is
      2:00 am meet
      at 20:00 till 11:00 PM
    CONTENT
  }

  shared_examples 'time conversion in file' do
    it 'writes converted times to file' do
      expect(File.read(test_file_name)).to eq(
        <<~CONVERTED_CONTENT
          Time 12:00 AM (next day) is
          12:00 PM (same day) meet
          at 6:00 AM (next day) till 9:00 AM (next day)
        CONVERTED_CONTENT
      )
    end
  end
  
  describe '#run' do
    context 'without 3 command line arguments' do
      it 'displays usage' do
        expect { time_converter.run([]) }.to output(usage).to_stdout
      end
    end

    context 'with proper 3 command line arguments' do
      before do
        File.write(test_file_name, test_file_content)
        time_converter.run([test_file_name, '-5:00', '+5:00'])
      end
      
      include_examples 'time conversion in file'
    end
  end

  describe '#display_usage' do
    it 'displays usage' do
      expect { time_converter.send(:display_usage) }.to output(usage).to_stdout
    end
  end

  describe '#calculate_offset' do
    it 'calculates offset correctly' do
      expect(time_converter.send('calculate_offset', '-5:00', '+5:00')).to eq(BasicTime.new('10:00'))
    end
  end
  
  context 'uses offset to convert times' do
    before { time_converter.instance_variable_set(:@offset, BasicTime.new('10:00')) }
    
    describe '#convert_times_in_file' do
      before do
        File.write(test_file_name, test_file_content)
        time_converter.send(:convert_times_in_file, test_file_name)
      end

      include_examples 'time conversion in file'
    end

    describe '#convert_times_in_string' do
      it 'converts all times in string based on offset' do
        expect(time_converter.send(:convert_times_in_string, '10:00 18:00 3:15 AM 4:20 PM')).to eq(
          '8:00 PM (same day) 4:00 AM (next day) 1:15 PM (same day) 2:20 AM (next day)'
        )
      end
    end
  end
end
