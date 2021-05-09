require_relative 'simple_time'

class TimeConverter
  def initialize(source_file_path, source_timezone, destination_timezone)
    @source_file_path = source_file_path
    @offset = calculate_offset(source_timezone, destination_timezone)
  end
  
  def run
    File.write(
      @source_file_path, 
      convert_times(File.read(@source_file_path))
    )
  end

  private

  def calculate_offset(source_timezone, destination_timezone)
    SimpleTime.new(destination_timezone) - SimpleTime.new(source_timezone)
  end

  def convert_times(content)
    content.gsub(/\d{1,2}:\d{2}/) { |time| SimpleTime.new(time) + @offset }
  end
end

if __FILE__ == $0
  TimeConverter.new(*ARGV).run
end
