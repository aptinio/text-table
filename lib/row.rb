module Text
  class Table
    class Row
      attr_reader :table, :cells

      def initialize(row_input, table)
        @table = table
        row_input = [row_input].flatten
        @cells = row_input.first == :separator ? :separator : row_input.map do |cell_input|
          Cell.new(cell_input.is_a?(Hash) ? cell_input.merge(:row => self) : {:value => cell_input}.merge(:row => self))
        end
      end

      def to_s
        if cells == :separator
          table.separator
        else
          ([table.horizontal_boundary] * 2).join(
            cells.map(&:to_s).join table.horizontal_boundary
          ) + "\n"
        end
      end

    end
  end
end