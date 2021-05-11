class BasicTime
  attr_accessor :hours, :minutes

  def initialize(time_string)
    @hours = 0
    @minutes = 0
    @day_difference = 0
    parse_time(time_string)
  end

  def ==(other)
    @hours == other.hours && @minutes == other.minutes
  end

  def +(other)
    @hours += other.hours
    @minutes += other.minutes
    calculate_carry
  end

  def -(other)
    @hours -= other.hours
    @minutes -= other.minutes
    calculate_carry
  end  

  def to_s
    "#{format_hours_to_12_hour}:#{format_minutes} #{format_am_pm} (#{format_day_difference})"
  end

  private

  def parse_time(time_string)
    @hours, @minutes = time_string.split(':').map(&:to_i)
    @hours = (@hours + 12) % 24 if time_string[-2..-1].upcase == 'PM'
  end

  def calculate_carry
    @hours += @minutes / 60
    @minutes %= 60
    @day_difference += @hours / 24
    @hours %= 24
    self
  end

  def format_hours_to_12_hour
    (@hours - 1) % 12 + 1
  end

  def format_minutes
    format('%02d', @minutes)
  end

  def format_am_pm
    @hours < 12 ? 'AM' : 'PM'
  end

  def format_day_difference
    case @day_difference
    when -1 then 'previous day'
    when 0 then 'same day'
    when 1 then 'next day'
    end
  end
end
