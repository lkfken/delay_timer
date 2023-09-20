require 'logger'
require 'ruby-progressbar'
require_relative '../lapse'

class DelayTimer
  class Base
    attr_reader :now, :delay_until, :logger, :debug

    def initialize(delay_until:, now: DateTime.now, logger: Logger.new($stderr), debug: false)
      @now         = now
      @delay_until = delay_until
      @logger      = logger
      @debug       = debug
    end

    def lapse
      @lapse ||= begin
        interval          = ::Lapse.new(:time_begin => now, :time_end => delay_until)
        interval.time_end = interval.time_end.next_day while interval.specified_time_has_passed?
        interval
      end
    end

    def specified_time_has_passed?
      specified_time < now
    end

    def start
      logger.info lapse.to_s #unless debug
      pause unless debug
    end

    def specified_time
      @specified_time ||= begin
        case delay_until
        when String
          Time.parse(delay_until)
        when DateTime
          delay_until
        when Date, Time
          delay_until.to_datetime
        else
          raise "Don't know how to handle #{delay_until.class}!"
        end
      end
    end

    def lapse_seconds
      lapse.sec
    end

    alias_method :total_seconds, :lapse_seconds

    private

    def pause
      title, seconds = lapse.wait_display, lapse.sec
      progressbar    = ProgressBar.create(title: title, :total => seconds)
      (1..seconds).each do
        progressbar.increment
        sleep(1)
      end
    end
  end
end