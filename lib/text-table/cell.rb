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

      # 0 base index of what row of __data__ the cell belongs to
      attr_reader :row_index

      def initialize(options = {}) #:nodoc:
        @value        = options[:value].to_s
        @row          = options[:row]
        @align        = options[:align]   || :left
        @colspan      = options[:colspan] || 1
        @row_index    = options[:ri]
        @column_index = options[:ci]
      end

      def to_s #:nodoc:
        aligned_value = case align
        when :left
          value.ljust cell_width
        when :right
          value.rjust cell_width
        when :center
          value.center cell_width
        end
        
        adjusted_value = table.formatter.call(value,column_index,row_index)

        aligned_value.sub!(value,adjusted_value)

        ([' ' * table.horizontal_padding]*2).join aligned_value 
      end

      def table #:nodoc:
        row.table
      end

      # 0 base index of what column of __data__ the cell belongs to
      def column_index
        row.cells[0...@column_index].map(&:colspan).inject(0, &:+)
      end

      # How many characters wide the cell should be not including padding
      def cell_width
        (0...colspan).map {|i| table.column_widths[column_index + i]}.inject(&:+) + (colspan - 1)*(2*table.horizontal_padding + table.horizontal_boundary.length)
      end

    end
  end
end