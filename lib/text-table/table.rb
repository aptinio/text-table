module Text #:nodoc:
  class Table

    # An array of table headers
    #
    attr_accessor :head

    # An array of arrays (rows or separators)
    #
    attr_accessor :rows

    # An array representing the foot of the table

    attr_accessor :foot

    # The vertical boundary.  Default is "<tt>-</tt>"
    #
    attr_accessor :vertical_boundary

    # The horizontal boundary.  Default is "<tt>|</tt>"
    #
    attr_accessor :horizontal_boundary

    # The boundary intersection.  Default is "<tt>+</tt>"
    #
    attr_accessor :boundary_intersection

    # The amount of padding (spaces) added to the left and right of cell contents.  Default is <tt>1</tt>
    #
    attr_accessor :horizontal_padding

    # An object that responds to #call which formats the text after alignment has occured.
    # Useful for colorizing
    attr_accessor :formatter

    #  You could create a Text::Table object by passing an options hash:
    #
    #      table = Text::Table.new(:head => ['A', 'B'], :rows => [['a1', 'b1'], ['a2', 'b2']])
    #
    #  Or by passing a block:
    #
    #      table = Text::Table.new do |t|
    #        t.head = ['A', 'B']
    #        t.rows = [['a1', 'b1']]
    #        t.rows << ['a2', 'b2']
    #      end
    #
    #      table.to_s
    #
    #      #    +----+----+
    #      #    | A  | B  |
    #      #    +----+----+
    #      #    | a1 | b1 |
    #      #    | a2 | b2 |
    #      #    +----+----+
    #
    #
    #  ==== Aligning Cells and Spanning Columns
    #
    #  Alignment and column span can be specified by passing a cell as a Hash object.
    #
    #  The acceptable aligments are <tt>:left</tt>, <tt>:center</tt> and <tt>:right</tt>.
    #
    #  Cells and footers are aligned to the left by default, while headers are centered by default.
    #
    #      table = Text::Table.new do |t|
    #        t.head = ['Heading A', 'Heading B']
    #        t.rows << ['a1', 'b1']
    #        t.rows << ['a2', {:value => 'b2', :align => :right}]
    #        t.rows << ['a3', 'b3']
    #        t.rows << [{:value => 'a4', :colspan => 2, :align => :center}]
    #      end
    #
    #      puts table
    #
    #      #    +-----------+-----------+
    #      #    | Heading A | Heading B |
    #      #    +-----------+-----------+
    #      #    | a1        | b1        |
    #      #    | a2        |        b2 |
    #      #    | a3        | b3        |
    #      #    |          a4           |
    #      #    +-----------+-----------+
    #
    #
    #  ==== Adding a Separator
    #
    #  You can add a separator by inserting <tt>:separator</tt> symbols between the rows.
    #
    #      Text::Table.new :rows => [
    #        ['a', 'b'],
    #        ['c', 'd'],
    #        :separator,
    #        ['e', 'f'],
    #        :separator,
    #        ['g', 'h']
    #      ]
    #
    #      #    +---+---+
    #      #    | a | b |
    #      #    | c | d |
    #      #    +---+---+
    #      #    | e | f |
    #      #    +---+---+
    #      #    | g | h |
    #      #    +---+---+
    #
    #
    #  ==== Other Options
    #
    #  Cell padding and table boundaries can be modified.
    #
    #      Text::Table.new :rows => [['a', 'b'], ['c', 'd']],
    #                      :horizontal_padding    => 3,
    #                      :vertical_boundary     => '=',
    #                      :horizontal_boundary   => ':',
    #                      :boundary_intersection => 'O'
    #
    #      #    O=======O=======O
    #      #    :   a   :   b   :
    #      #    :   c   :   d   :
    #      #    O=======O=======O
    #
    def initialize(options = {})
      @vertical_boundary     = options[:vertical_boundary    ] || '-'
      @horizontal_boundary   = options[:horizontal_boundary  ] || '|'
      @boundary_intersection = options[:boundary_intersection] || '+'
      @horizontal_padding    = options[:horizontal_padding   ] || 1
      @head = options[:head]
      @rows = options[:rows] || []
      @foot = options[:foot]
      @formatter = options[:formatter] || Proc.new do |value,column_index,row_index|
        value
      end

      yield self if block_given?
    end

    def text_table_rows #:nodoc:
      row_arr = []
      rows.to_a.each_with_index do |row_input,ri|
        row_arr << Row.new(row_input, self, ri)
      end
      row_arr
    end

    def text_table_head #:nodoc:
      Row.new(
        head.map {|h| hashify(h, {:align => :center})},
        self,
        -1
      ) if head
    end

    def text_table_foot #:nodoc:
      Row.new(foot, self,-2) if foot
    end

    def all_text_table_rows #:nodoc:
      all = text_table_rows
      all.unshift text_table_head if head
      all << text_table_foot if foot
      all
    end

    def column_widths #:nodoc:
      all_text_table_rows.reject {|row| row.cells == :separator}.map do |row|
        row.cells.map {|cell| [(cell.value.length/cell.colspan.to_f).ceil] * cell.colspan}.flatten
      end.transpose.map(&:max)
    end

    def separator #:nodoc:
      ([@boundary_intersection] * 2).join(
        column_widths.map {|column_width| @vertical_boundary * (column_width + 2*@horizontal_padding)}.join(@boundary_intersection)
      ) + "\n"
    end

    # Renders a pretty plain-text table.
    #
    def to_s
      rendered_rows = []
      rendered_rows.unshift [separator, text_table_head.to_s] if head
      rendered_rows += [separator] + text_table_rows.map(&:to_s) + [separator]
      rendered_rows << [text_table_foot.to_s, separator] if foot
      rendered_rows.join
    end

    #  Aligns the cells and the footer of a column.
    #
    #    table = Text::Table.new :rows => [%w(a bb), %w(aa bbb), %w(aaa b)]
    #    puts table
    #
    #    #    +-----+-----+
    #    #    | a   | bb  |
    #    #    | aa  | bbb |
    #    #    | aaa | b   |
    #    #    +-----+-----+
    #
    #    table.align_column 2, :right
    #
    #    #    +-----+-----+
    #    #    | a   |  bb |
    #    #    | aa  | bbb |
    #    #    | aaa |   b |
    #    #    +-----+-----+
    #
    #  Note that headers, spanned cells and cells with explicit alignments are not affected by <tt>align_column</tt>.
    #
    def align_column(column_number, alignment)
      set_alignment = Proc.new do |row, column_number_block, alignment_block|
        cell = row.find do |cell_row|
          row[0...row.index(cell_row)].map {|c| c.is_a?(Hash) ? c[:colspan] || 1 : 1}.inject(0, &:+) == column_number_block - 1
        end
        row[row.index(cell)] = hashify(cell, {:align => alignment_block}) if cell and not(cell.is_a?(Hash) && cell[:colspan].to_i > 0)
      end
      rows.each do |row|
        set_alignment.call(row, column_number, alignment)
      end
      set_alignment.call(foot, column_number, alignment) if foot
      return self
    end

    def hashify(cell, defaults = {}) #:nodoc:
      defaults.merge(cell.is_a?(Hash) ? cell : {:value => cell})
    end

  end
end
