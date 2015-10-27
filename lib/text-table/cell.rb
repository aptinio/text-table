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

      def text_width
        char_count + value.chars.count { |c| c.bytesize > 2 }
      end

      def char_count
        @char_count ||= value.split('').length
      end

      def to_s #:nodoc:
        if RUBY_VERSION < '1.9'
          len = value.bytesize + cell_width - text_width
        else
          len = value.length + cell_width - text_width
        end

      ([' ' * table.horizontal_padding]*2).join case align
        when :left
          value.ljust len
        when :right
          value.rjust len
        when :center
          value.center len
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
