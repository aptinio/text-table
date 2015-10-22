module Text #:nodoc:
  class Table
    class Cell

      # The object whose <tt>to_s</tt> method is called when rendering the cell.
      #
      attr_accessor :value
      
      # Text alignment.  Acceptable values are <tt>:left</tt> (default),
      # <tt>:center</tt> and <tt>:right</tt>
      #
      attr_accessor :align

      # Positive integer specifying the number of columns spanned
      #
      attr_accessor :colspan
      attr_reader :row #:nodoc:

      def initialize(options = {}) #:nodoc:
        @value  = options[:value].to_s
        @row     = options[:row]
        @align   = options[:align  ] || :left
        @colspan = options[:colspan] || 1
      end

      # visible width: without terminal escapes
      def width #:nodoc:
        value.gsub(/\033\[[^m]+m/, '').length
      end

      def to_s #:nodoc:
        invisible = value.length - width
      ([' ' * table.horizontal_padding]*2).join case align
        when :left
          value.ljust cell_width+invisible
        when :right
          value.rjust cell_width+invisible
        when :center
          value.center cell_width+invisible
        end
      end

      def table #:nodoc:
        row.table
      end

      def column_index #:nodoc:
        row.cells[0...row.cells.index(self)].map(&:colspan).inject(0, &:+)
      end

      def cell_width #:nodoc:
        (0...colspan).map {|i| table.column_widths[column_index + i]}.inject(&:+) + (colspan - 1)*(2*table.horizontal_padding + table.horizontal_boundary.length)
      end

    end
  end
end
