require 'spec_helper'
require 'benchmark'

describe Text::Table, 'performance' do
  it 'is linear relative to row count' do
    base = time_to_render_num_of_rows 30
    time = time_to_render_num_of_rows 300

    time.should_not > base * 12
  end

  def time_to_render_num_of_rows(num)
    GC.start

    Benchmark.realtime do
      Text::Table.new(rows: Array.new(num)).to_s
    end
  end
end
