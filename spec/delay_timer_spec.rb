require 'rspec'
require_relative '../lib/delay_timer'
require 'pp'

describe DelayTimer do
  context 'regular usage (within 24 hours)' do
    let(:minutes_in_day) { 1 * 24 * 60 }
    let(:adj_minutes) { Rational(3, minutes_in_day) }
    let(:now) { DateTime.now }
    let(:timer) { DelayTimer.create(:delay_until => (now + adj_minutes), :debug => true) }
    it '#specified_time' do
      expect(timer.specified_time).to eq(now + adj_minutes)
    end
    it '#total_seconds' do
      expect(timer.total_seconds).to eq(180)
    end
    it '#start' do
      timer.start
    end
  end

  context 'wait more than 24 hours' do
    let(:time) { DateTime.now.next_day(7) }
    let(:timer) { DelayTimer.create(:delay_until => time, :debug => true) }
    it '#specified_time' do
      expect(timer.specified_time).to eq(time)
    end
    it '#specified_time_has_passed?' do
      expect(timer.send(:specified_time_has_passed?)).to be_falsey
    end
    it '#total_seconds' do
      expect(timer.total_seconds).to eq(604800)
    end
    it '#start' do
      timer.start
    end
  end

  context 'end time before start time' do
    let(:timer) { DelayTimer.create(:delay_until => (DateTime.now - (30/24.0)), :debug => true) }
    it '#specified_time_has_passed?' do
      expect(timer.send(:specified_time_has_passed?)).to be_truthy
    end
    it '#start' do
      timer.start
    end
  end

  context 'end time before start time' do
    let(:timer) { DelayTimer.create(:delay_until => Time.parse('8:52am'), :debug => true) }
    it '#specified_time_has_passed?' do
      expect(timer.send(:specified_time_has_passed?)).to be_truthy
    end
    it '#start' do
      timer.start
    end
  end

  context 'run the block after pause' do
    it '.run' do
      DelayTimer.run(:delay_until => Time.parse('3:48pm'), :debug => true) { puts 'Hello' }
    end
  end
end