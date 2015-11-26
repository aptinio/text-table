require 'forwardable'

class Text::Table
  class Cell
    extend Forwardable
    attr_reader :value, :row, :cols
    def_delegators :row, :table
    def_delegators :table, :distance_between_cols, :horizontal_padding

    def initialize(
      value: ,
      row: ,
      cols: ,
      align: nil
    )

      @value = String(value)
      @row = row
      @cols = cols
      @align = align

      update_col_widths
    end

    def update_col_widths
      total_width = cols.map(&:width).reduce(&:+) +
        (colspan - 1) * distance_between_cols

      return if total_width > value_length

      remaining = value_length

      cols[0..-2].each do |col|
        width = if total_width > 0
          (col.width.to_f / total_width * value_length)
        else
          (value_length / colspan)
        end.round

        col.width = [col.width, width].max
        remaining = remaining - width - distance_between_cols
      end

      cols.last.width = remaining
    end

    def to_s
      value.send(justification_method, width).center(width + 2 * horizontal_padding)
    end

    def justification_method
      case align
      when :right then :rjust
      when :center then :center
      else :ljust
      end
    end

    def width
      cols.map(&:width).reduce(&:+) + (colspan - 1) * distance_between_cols
    end

    def colspan
      cols.size
    end

    def align
      @align ||
        row.align ||
        cols.first.align ||
        :left
    end

    def value_length
      value.length
    end
  end
end
