require_relative 'basic_time'

class TimeConverter
  def initialize
    @offset = nil
  end
  
  def run(argv)
    return display_usage unless argv.length == 3

    @offset = calculate_offset(argv[1], argv[2])
    convert_times_in_file(argv[0])
  end

  private

  def display_usage
    print <<~USAGE
      <source-file> <source-timezone> <destination-timezone>
      Description: converts times in file in 12 hour or 24 hour format into times of the destination timezone in 12 hour format
      
      source-file: file with times
      source-timezone: timezone of times in source file
      destination-timezone: timezone you wish to convert all times to
    USAGE
  end

  def calculate_offset(source_timezone, destination_timezone)
    BasicTime.new(destination_timezone) - BasicTime.new(source_timezone)
  end  

  def convert_times_in_file(source_file_path)
    File.write(
      source_file_path, 
      convert_times_in_string(File.read(source_file_path))
    )
  end

  def convert_times_in_string(content)
    content.gsub(/\d{1,2}:\d{2}(?: ?[ap]m)?/i) { |time| BasicTime.new(time) + @offset }
  end
end

if __FILE__ == $0
  TimeConverter.new.run(*ARGV)
end
