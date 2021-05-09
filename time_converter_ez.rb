require 'date'

class TimeConverter
  def initialize(source_file_path, source_timezone, destination_timezone)
    @source_file_path = source_file_path
    @source_timezone = source_timezone
    @destination_timezone = destination_timezone
  end

  def run
    File.write(
      @source_file_path, 
      File.read(@source_file_path)
      .gsub(/\d{1,2}(?::\d{2})? ?[ap]m/i) { |time| convert_time_12hr(time) }
      .gsub(/(?!\d{1,2}:\d{2} ?[ap]m)\d{1,2}:\d{2}/i) { |time| convert_time_24hr(time) }
    )
  end

  def convert_time_12hr(source_time)
    st = DateTime.parse("#{source_time}#{@source_timezone}")
    dt = st.new_offset(@destination_timezone)

    day =
      if dt.day > st.day
        'next day'
      elsif dt.day < st.day
        'previous day'
      else
        'same day'
      end

    dt.strftime("%I:%M %P (#{day})")
  end

  def convert_time_24hr(source_time)
    st = DateTime.parse("#{source_time}#{@source_timezone}")
    dt = st.new_offset(@destination_timezone)

    day =
      if dt.day > st.day
        'next day'
      elsif dt.day < st.day
        'previous day'
      else
        'same day'
      end

    dt.strftime("%R (#{day})")
  end
end

if __FILE__ == $0
  TimeConverter.new(*ARGV).run
end
