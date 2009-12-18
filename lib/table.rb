%w(cell row).each do |lib|
  require File.expand_path(File.dirname(__FILE__) + "/../lib/#{lib}")
end

module Text
  class Table
    attr_accessor(
      :head, :rows, :foot,
      :vertical_boundary, :horizontal_boundary, :boundary_intersection,
      :horizontal_padding
    )

    def initialize(options = {})
      @vertical_boundary     = options[:vertical_boundary    ] || '-'
      @horizontal_boundary   = options[:horizontal_boundary  ] || '|'
      @boundary_intersection = options[:boundary_intersection] || '+'
      @horizontal_padding    = options[:horizontal_padding   ] || 1
      @head = options[:head]
      @rows = options[:rows]
      yield self if block_given?
    end

    def text_table_rows
      rows.to_a.map {|row_input| Row.new(row_input, self)}
    end

    def text_table_head
      Row.new(head, self) if head
    end

    def text_table_foot
      Row.new(foot, self) if foot
    end

    def all_text_table_rows
      all = text_table_rows
      all.unshift text_table_head if head
      all << text_table_foot if foot
      all
    end

    def column_widths
      all_text_table_rows.reject {|row| row.cells == :separator}.map do |row|
        row.cells.map {|cell| [cell.column_width] * cell.colspan}.flatten
      end.transpose.map(&:max)
    end

    def separator
      ([@boundary_intersection] * 2).join(
        column_widths.map {|column_width| @vertical_boundary * (column_width + 2*@horizontal_padding)}.join @boundary_intersection
      ) + "\n"
    end

    def to_s
      rendered_rows = [separator] + text_table_rows.map(&:to_s) + [separator]
      rendered_rows.unshift [separator, text_table_head.to_s] if head
      rendered_rows << [text_table_foot.to_s, separator] if foot
      rendered_rows.join
    end

  end
end

module Enumerable
  def to_text_table(options = {})
    table = Text::Table.new :rows => self.to_a
    table.head = table.rows.shift if options[:first_row_is_head]
    table.foot = table.rows.pop   if options[:last_row_is_foot]
    table
  end
end