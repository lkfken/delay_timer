require_relative 'delay_timer/version'
require_relative 'delay_timer/base'

class DelayTimer
  def self.run(*args)
    timer = DelayTimer::Base.new(*args)
    timer.start
    yield
  end

  def self.create(**args)
    DelayTimer::Base.new(**args)
  end
end
