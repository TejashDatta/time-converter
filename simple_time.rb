class SimpleTime
  attr_accessor :hours, :minutes

  def initialize(time_string)
    @hours, @minutes = time_string.split(':').map(&:to_i)
    @day_carry = 0
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
    "#{@hours}:#{format('%02d', @minutes)} (#{format_day_carry})"
  end

  private

  def calculate_carry
    @hours += @minutes / 60
    @minutes %= 60
    @day_carry += @hours / 24
    @hours %= 24
    self
  end

  def format_day_carry
    case @day_carry
    when -1 then 'previous day'
    when 0 then 'same day'
    when 1 then 'next day'
    end
  end
end
