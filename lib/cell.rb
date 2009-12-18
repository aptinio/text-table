module Text
  class Table
    class Cell
      attr_accessor :value, :align, :colspan
      attr_reader :row

      def initialize(options = {})
        @value  = options[:value].to_s
        @row     = options[:row]
        @align   = options[:align  ] || :left
        @colspan = options[:colspan] || 1
      end

      def to_s
      ([' ' * table.horizontal_padding]*2).join case align
        when :left
          value.ljust cell_width
        when :right
          value.rjust cell_width
        when :center
          value.center cell_width
        end
      end

      def table
        row.table
      end

      def column_width
        (value.length/colspan.to_f).ceil
      end

      def column_index
        row.cells[0...row.cells.index(self)].map(&:colspan).reduce(0, :+)
      end

      def cell_width
        colspan.times.map {|i| table.column_widths[column_index + i]}.reduce(:+) + (colspan - 1)*(2*table.horizontal_padding + table.horizontal_boundary.length)
      end

    end
  end
end