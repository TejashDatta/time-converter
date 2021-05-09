class BasicTime
  attr_accessor :hours, :minutes

  def initialize(time_string)
    @hours = 0
    @minutes = 0
    @day_carry = 0
    parse_time(time_string)
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

  def ==(other)
    @hours == other.hours && @minutes == other.minutes
  end

  def to_s
    "#{format_hours_to_12_hour}:#{format('%02d', @minutes)} #{am_pm_from_hours} (#{format_day_carry})"
  end

  private

  def parse_time(time_string)
    @hours, @minutes = time_string.split(':').map(&:to_i)
    @hours = (@hours + 12) % 24 if time_string[-2..-1].upcase == 'PM'
  end

  def calculate_carry
    @hours += @minutes / 60
    @minutes %= 60
    @day_carry += @hours / 24
    @hours %= 24
    self
  end

  def format_hours_to_12_hour
    formatted_hours = @hours % 12
    formatted_hours.zero? ? 12 : formatted_hours
  end

  def am_pm_from_hours
    @hours < 12 ? 'AM' : 'PM'
  end

  def format_day_carry
    case @day_carry
    when -1 then 'previous day'
    when 0 then 'same day'
    when 1 then 'next day'
    end
  end
end
