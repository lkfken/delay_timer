require 'logger'
require 'ruby-progressbar'

class DelayTimer
  class Base
    attr_reader :now, :delay_until, :logger, :debug

    def initialize(delay_until:, now: DateTime.now, logger: Logger.new($stderr), debug: false)
      @now         = now
      @delay_until = delay_until
      @logger      = logger
      @debug       = debug
    end

    def start
      if lapse_seconds > (24 * 60 * 60)
        now_time    = now.strftime('%c')
        target_time = specified_time.strftime('%c')
        wait = Time.at(lapse_seconds).utc.to_datetime.prev_day.strftime('%d:%H:%M:%S')
      else
        now_time    = now.strftime('%H:%M:%S')
        target_time = specified_time.strftime('%H:%M:%S')
        wait = Time.at(lapse_seconds).utc.to_datetime.strftime('%H:%M:%S')
      end
      msg = ["Time now: #{now_time}.", "Target: #{target_time}.", "Wait: #{wait}."].join(' ')
      logger.info msg unless debug

      pause(lapse_seconds) unless debug
    end

    def specified_time
      @specified_time ||= begin
        case delay_until
        when String
          Time.parse(delay_until)
        when Time, DateTime
          delay_until
        when Date
          delay_until.to_datetime
        else
          raise "Don't know how to handle #{delay_until.class}!"
        end
      end
    end

    def lapse_seconds
      @lapse_seconds ||= begin
        time = specified_time
        time = time.to_datetime.next_day.to_time if specified_time_has_passed?
        ((time - now)*24*60*60).ceil.to_i
      end
    end

    alias_method :total_seconds, :lapse_seconds

    private

    def specified_time_has_passed?
      specified_time < now
    end

    def pause(seconds)
      title       = "Wait #{Time.at(seconds).utc.strftime('%H:%M:%S')}"
      progressbar = ProgressBar.create(title: title, :total => seconds)
      (1..seconds).each do
        progressbar.increment
        sleep(1)
      end
    end
  end
end