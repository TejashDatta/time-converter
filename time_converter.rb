class TimeConverter
  def initialize(argv)
    @source_file_path = argv[0]
    @source_timezone = argv[1]
    @destination_timezone = argv[2]
  end

  def run
    contents = File.read(@source_file_path)
    contents = contents.gsub(/\d{1,2}:\d{2}/) { |time| convert_time(time) }
    File.write(@source_file_path, contents)
  end

  def convert
  end

  def convert_time

  end
end

if __FILE__ == $0
  TimeConverter.new(*ARGV).run
end
