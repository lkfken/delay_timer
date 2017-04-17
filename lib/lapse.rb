class Lapse
  attr_reader :time_begin
  attr_accessor :time_end

  DAY_IN_SEC = 24*60*60

  def initialize(time_begin:, time_end:)
    @time_begin = time_begin.to_datetime
    @time_end   = time_end.to_datetime
  end

  def to_s
    ["Time now: #{time_begin_display}.", "Target: #{time_end_display}.", "Wait: #{wait_display}."].join(' ')
  end

  def time_begin_display
    at_least_one_day? ? time_begin.strftime('%c') : time_begin.strftime('%H:%M:%S')
  end

  def time_end_display
    at_least_one_day? ? time_end.strftime('%c') : time_end.strftime('%H:%M:%S')
  end

  def wait_display
    at_least_one_day? ? duration.prev_day.strftime('%d:%H:%M:%S') : duration.strftime('%H:%M:%S')
  end

  def duration
    Time.at(sec).utc.to_datetime
  end

  def at_least_one_day?
    sec >= DAY_IN_SEC
  end

  def sec
    ((time_end - time_begin) * DAY_IN_SEC).ceil.to_i
  end

  def specified_time_has_passed?
    time_end < time_begin
  end

end