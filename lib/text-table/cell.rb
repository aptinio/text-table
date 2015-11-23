class Text::Table
  class Cell
    attr_reader :value, :row, :cols, :colspan

    def initialize(
      value: ,
      row: ,
      cols: ,
      align: nil,
      colspan:
    )

      @value = String(value)
      @row = row
      @cols = cols
      @align = align
      @colspan = colspan
      cols.update_width(self)
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
      (cols.width * colspan) + ((colspan - 1) * (2 * horizontal_padding + horizontal_boundary.length))
    end

    def align
      @align || row.align || cols.align || :left
    end

    def horizontal_padding
      table.horizontal_padding
    end

    def horizontal_boundary
      table.horizontal_boundary
    end

    def table
      row.table
    end

    def value_length
      value.length
    end
  end
end
