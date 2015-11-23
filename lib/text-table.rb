module Text
end

require 'text-table/head'
require 'text-table/foot'
require 'text-table/row'
require 'text-table/column'
require 'text-table/separator'

class Text::Table
  attr_reader :head, :rows, :foot, :columns,
    :horizontal_boundary, :vertical_boundary, :boundary_intersection,
    :horizontal_padding

  def initialize(
    head: nil,
    rows: [],
    foot: nil,
    horizontal_boundary: '|',
    vertical_boundary: '-',
    boundary_intersection: '+',
    horizontal_padding: 1
  )

    @columns = Hash.new { |columns, key| columns[key] = Column.new }
    @horizontal_boundary = horizontal_boundary
    @vertical_boundary = vertical_boundary
    @boundary_intersection = boundary_intersection
    @horizontal_padding = horizontal_padding
    self.head = head
    self.rows = rows || []
    self.foot = foot
  end

  def to_s
    [
      head.to_s,
      separator,
      rows.map(&:to_s).join,
      separator,
      foot.to_s
    ].join
  end

  def separator
    @separator = Separator.new(self)
  end

  def width
    columns.values.map(&:width).reduce(&:+) +
      (horizontal_padding * 2 * columns.size) +
      (horizontal_boundary.length * (columns.size + 1))
  end

  def head=(head)
    @head = Head.new(head, self) if head
  end

  def rows=(rows)
    @rows = rows.map { |row| Row.new(row, self) }
  end

  def foot=(foot)
    @foot = Foot.new(foot, self) if foot
  end

  def align_column(number, align)
    columns[number - 1].align = align
  end
end

module Enumerable
  unless method_defined? :to_table
    def to_table(*args)
      if require 'text-table/core_ext/enumerable'
        warn "Extension to Enumerable will be disabled by default. Require 'text-table/core_ext/enumerable' to enable."
      end
      to_text_table(*args)
    end
  end
end
