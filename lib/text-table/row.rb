module Text #:nodoc:
  class Table

    # A Text::Table::Row belongs to a Text::Table object and can have many Text::Table::Cell objects.
    # It handles the rendering of rows and inserted separators.
    #
    class Row
      attr_reader :table #:nodoc:
      attr_reader :row_index #:nodoc:
      attr_reader :row_input #:nodoc:

      def initialize(row_input, table, ri) #:nodoc:
        @table = table
        @row_index = ri
        @row_input = [row_input].flatten
      end

      def cells #:nodoc:
        if row_input.first == :separator
          cells = :separator
        else
          cells = []
          row_input.each_with_index do |cell_input,ci|
            opts = cell_input.is_a?(Hash) ? cell_input : {:value => cell_input}
            opts[:row] = self
            opts[:ri] = row_index
            opts[:ci] = ci
            cells << Cell.new(opts)
          end
        end

        cells
      end

      def to_s #:nodoc:
        if cells == :separator
          table.separator
        else
          ([table.horizontal_boundary] * 2).join(
            cells.map(&:to_s).join(table.horizontal_boundary)
          ) + "\n"
        end
      end

    end
  end
end