require 'text-table'
require 'benchmark'

RSpec.describe Text::Table, 'performance' do
  it 'is linear relative to row count' do
    base = time_to_render_num_of_rows  1_000
    time = time_to_render_num_of_rows 10_000

    expect(time).to be < base * 20
  end

  def time_to_render_num_of_rows(num)
    GC.start

    Benchmark.measure {
      Text::Table.new(rows: Array.new(num) { Array.new(10) { 'foo' } }).to_s
    }.total
  end
end
