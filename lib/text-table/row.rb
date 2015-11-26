require 'text-table/cell'

class Text::Table
  class Row
    attr_reader :cells, :table, :align

    def self.new(row, table)
      return table.separator if row == :separator
      super
    end

    def initialize(row, table)
      @table = table
      self.cells = row
    end

    def cells=(inputs)
      i = 0
      @cells = Array(inputs).map { |input|
        input = input.respond_to?(:to_h) ? input : { value: input }
        colspan = input.delete(:colspan) { |_| 1 }
        input = input.merge(
          row: self,
          cols: (i...(i + colspan)).map { |j| columns[j] }
        )
        i += colspan
        Cell.new(input)
      }
    end

    def to_s
      [
        horizontal_boundary,
        cells.map(&:to_s).join(horizontal_boundary),
        horizontal_boundary
      ].join + "\n"
    end

    def horizontal_boundary
      table.horizontal_boundary
    end

    def columns
      table.columns
    end
  end
end
