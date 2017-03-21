require 'rspec'
require_relative '../lib/delay_timer'
require 'pp'

describe DelayTimer do
  let(:adj_minutes) { 3 * 60 }
  let(:now) { Time.now }
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