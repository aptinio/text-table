require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Text::Table do

  before(:each) do
    @head = %w( a    bb   ccc  dddd )
    @rows = [
            %w( aa   bbb  cccc d    ),
            %w( aaa  bbbb c    dd   ),
    ]
    @foot = %w( aaaa b    cc   ddd  )
    @table = Text::Table.new :rows => @rows, :head => @head, :foot => @foot
  end

  it 'should initialize with an empty array for its rows as default' do
    @table = Text::Table.new
    @table.rows.should == []
  end

  describe 'should allow setting of attributes' do

    it 'passed as an options hash' do
      @table = Text::Table.new :rows => @rows
      @table.rows.should == @rows
      @table = Text::Table.new :rows => @rows, :horizontal_padding => 2
      @table.rows.should == @rows
      @table.horizontal_padding.should == 2
    end

    it 'inside a block' do
      @table = Text::Table.new do |t|
        t.rows = @rows
      end
      @table.rows.should == @rows

      @table = Text::Table.new do |t|
        t.horizontal_padding = 2
      end
      @table.horizontal_padding.should == 2
    end

  end

  describe 'should properly render' do

    it 'column widths' do
      @table.column_widths.should == [4, 4, 4, 4]
    end

    it 'rows' do
      @table = Text::Table.new :rows => @rows
      @table.to_s.should == <<-EOS.deindent
        +-----+------+------+----+
        | aa  | bbb  | cccc | d  |
        | aaa | bbbb | c    | dd |
        +-----+------+------+----+
      EOS
    end

    it 'rows with unequal number of cells'

    it 'headers' do
      @table = Text::Table.new :rows => @rows, :head => @head
      @table.to_s.should == <<-EOS.deindent
        +-----+------+------+------+
        |  a  |  bb  | ccc  | dddd |
        +-----+------+------+------+
        | aa  | bbb  | cccc | d    |
        | aaa | bbbb | c    | dd   |
        +-----+------+------+------+
      EOS
    end

    it 'footers' do
      @table = Text::Table.new :rows => @rows, :foot => @foot
      @table.to_s.should == <<-EOS.deindent
        +------+------+------+-----+
        | aa   | bbb  | cccc | d   |
        | aaa  | bbbb | c    | dd  |
        +------+------+------+-----+
        | aaaa | b    | cc   | ddd |
        +------+------+------+-----+
      EOS
    end

    it "separators" do
      @table = Text::Table.new :rows => @rows.insert(1, :separator)
      @table.to_s.should == <<-EOS.deindent
        +-----+------+------+----+
        | aa  | bbb  | cccc | d  |
        +-----+------+------+----+
        | aaa | bbbb | c    | dd |
        +-----+------+------+----+
      EOS
    end

    it 'horizontal boundaries' do
      @table.horizontal_boundary = ':'
      @table.to_s.should == <<-EOS.deindent
        +------+------+------+------+
        :  a   :  bb  : ccc  : dddd :
        +------+------+------+------+
        : aa   : bbb  : cccc : d    :
        : aaa  : bbbb : c    : dd   :
        +------+------+------+------+
        : aaaa : b    : cc   : ddd  :
        +------+------+------+------+
      EOS
    end

    it 'vertical boundaries' do
      @table.vertical_boundary = '='
      @table.to_s.should == <<-EOS.deindent
        +======+======+======+======+
        |  a   |  bb  | ccc  | dddd |
        +======+======+======+======+
        | aa   | bbb  | cccc | d    |
        | aaa  | bbbb | c    | dd   |
        +======+======+======+======+
        | aaaa | b    | cc   | ddd  |
        +======+======+======+======+
      EOS
    end

    it 'boundary interserctions' do
      @table.boundary_intersection = '*'
      @table.to_s.should == <<-EOS.deindent
        *------*------*------*------*
        |  a   |  bb  | ccc  | dddd |
        *------*------*------*------*
        | aa   | bbb  | cccc | d    |
        | aaa  | bbbb | c    | dd   |
        *------*------*------*------*
        | aaaa | b    | cc   | ddd  |
        *------*------*------*------*
      EOS
    end

    it 'double horizontal boundaries' do
      @table.horizontal_boundary = '||'
      @table.boundary_intersection = '++'
      @table.to_s.should == <<-EOS.deindent
        ++------++------++------++------++
        ||  a   ||  bb  || ccc  || dddd ||
        ++------++------++------++------++
        || aa   || bbb  || cccc || d    ||
        || aaa  || bbbb || c    || dd   ||
        ++------++------++------++------++
        || aaaa || b    || cc   || ddd  ||
        ++------++------++------++------++
      EOS
    end

    it 'double horizontal boundaries with spanned cells' do
      @table.horizontal_boundary = '||'
      @table.boundary_intersection = '++'
      @table.rows << :separator
      @table.rows << [{:value => 'x', :colspan => 2, :align => :right}, 'c', 'd']
      @table.to_s.should == <<-EOS.deindent
        ++------++------++------++------++
        ||  a   ||  bb  || ccc  || dddd ||
        ++------++------++------++------++
        || aa   || bbb  || cccc || d    ||
        || aaa  || bbbb || c    || dd   ||
        ++------++------++------++------++
        ||            x || c    || d    ||
        ++------++------++------++------++
        || aaaa || b    || cc   || ddd  ||
        ++------++------++------++------++
      EOS
    end

    describe 'alignment of' do
      describe 'headers to the' do
        it 'left' do
          @table = Text::Table.new :rows => @rows, :head => @head.map {|h| {:value => h, :align => :left}}
          @table.to_s.should == <<-EOS.deindent
            +-----+------+------+------+
            | a   | bb   | ccc  | dddd |
            +-----+------+------+------+
            | aa  | bbb  | cccc | d    |
            | aaa | bbbb | c    | dd   |
            +-----+------+------+------+
          EOS
        end
        it 'center (default)' do
          @table = Text::Table.new :rows => @rows, :head => @head
          @table.to_s.should == <<-EOS.deindent
            +-----+------+------+------+
            |  a  |  bb  | ccc  | dddd |
            +-----+------+------+------+
            | aa  | bbb  | cccc | d    |
            | aaa | bbbb | c    | dd   |
            +-----+------+------+------+
          EOS
        end
        it 'right' do
          @table = Text::Table.new :rows => @rows, :head => @head.map {|h| {:value => h, :align => :right}}
          @table.to_s.should == <<-EOS.deindent
            +-----+------+------+------+
            |   a |   bb |  ccc | dddd |
            +-----+------+------+------+
            | aa  | bbb  | cccc | d    |
            | aaa | bbbb | c    | dd   |
            +-----+------+------+------+
          EOS
        end
      end
      describe 'cells to the' do
        it 'left (default)' do
          @table.to_s.should == <<-EOS.deindent
            +------+------+------+------+
            |  a   |  bb  | ccc  | dddd |
            +------+------+------+------+
            | aa   | bbb  | cccc | d    |
            | aaa  | bbbb | c    | dd   |
            +------+------+------+------+
            | aaaa | b    | cc   | ddd  |
            +------+------+------+------+
          EOS
        end
        it 'center' do
          @table = Text::Table.new :rows => @rows.map {|r| r.map {|c| {:value => c, :align => :center}}}, :head => @head, :foot => @foot
          @table.to_s.should == <<-EOS.deindent
            +------+------+------+------+
            |  a   |  bb  | ccc  | dddd |
            +------+------+------+------+
            |  aa  | bbb  | cccc |  d   |
            | aaa  | bbbb |  c   |  dd  |
            +------+------+------+------+
            | aaaa | b    | cc   | ddd  |
            +------+------+------+------+
          EOS
        end
        it 'right' do
          @table = Text::Table.new :rows => @rows.map {|r| r.map {|c| {:value => c, :align => :right}}}, :head => @head, :foot => @foot
          @table.to_s.should == <<-EOS.deindent
            +------+------+------+------+
            |  a   |  bb  | ccc  | dddd |
            +------+------+------+------+
            |   aa |  bbb | cccc |    d |
            |  aaa | bbbb |    c |   dd |
            +------+------+------+------+
            | aaaa | b    | cc   | ddd  |
            +------+------+------+------+
          EOS
        end
      end
      describe 'footers to the' do
        it 'left (default)' do
          @table = Text::Table.new :rows => @rows, :foot => @foot
          @table.to_s.should == <<-EOS.deindent
            +------+------+------+-----+
            | aa   | bbb  | cccc | d   |
            | aaa  | bbbb | c    | dd  |
            +------+------+------+-----+
            | aaaa | b    | cc   | ddd |
            +------+------+------+-----+
          EOS
        end
        it 'center' do
          @table = Text::Table.new :rows => @rows, :foot => @foot.map {|f| {:value => f, :align => :center}}
          @table.to_s.should == <<-EOS.deindent
            +------+------+------+-----+
            | aa   | bbb  | cccc | d   |
            | aaa  | bbbb | c    | dd  |
            +------+------+------+-----+
            | aaaa |  b   |  cc  | ddd |
            +------+------+------+-----+
          EOS
        end
        it 'right' do
          @table = Text::Table.new :rows => @rows, :foot => @foot.map {|f| {:value => f, :align => :right}}
          @table.to_s.should == <<-EOS.deindent
            +------+------+------+-----+
            | aa   | bbb  | cccc | d   |
            | aaa  | bbbb | c    | dd  |
            +------+------+------+-----+
            | aaaa |    b |   cc | ddd |
            +------+------+------+-----+
          EOS
        end
      end
    end
    describe 'last columns spanned by' do
      describe '2 cells aligned to the' do
        it 'left' do
          @table.rows << ['a', 'b', {:value => 'x', :colspan => 2}]
          @table.to_s.should == <<-EOS.deindent
            +------+------+------+------+
            |  a   |  bb  | ccc  | dddd |
            +------+------+------+------+
            | aa   | bbb  | cccc | d    |
            | aaa  | bbbb | c    | dd   |
            | a    | b    | x           |
            +------+------+------+------+
            | aaaa | b    | cc   | ddd  |
            +------+------+------+------+
          EOS
        end
        it 'center' do
          @table.rows << ['a', 'b', {:value => 'x', :colspan => 2, :align => :center}]
          @table.to_s.should == <<-EOS.deindent
            +------+------+------+------+
            |  a   |  bb  | ccc  | dddd |
            +------+------+------+------+
            | aa   | bbb  | cccc | d    |
            | aaa  | bbbb | c    | dd   |
            | a    | b    |      x      |
            +------+------+------+------+
            | aaaa | b    | cc   | ddd  |
            +------+------+------+------+
          EOS
        end
        it 'right' do
          @table.rows << ['a', 'b', {:value => 'x', :colspan => 2, :align => :right}]
          @table.to_s.should == <<-EOS.deindent
            +------+------+------+------+
            |  a   |  bb  | ccc  | dddd |
            +------+------+------+------+
            | aa   | bbb  | cccc | d    |
            | aaa  | bbbb | c    | dd   |
            | a    | b    |           x |
            +------+------+------+------+
            | aaaa | b    | cc   | ddd  |
            +------+------+------+------+
          EOS
        end
      end
      describe '3 cells aligned to the' do
        it 'left' do
          @table.rows << ['a', {:value => 'x', :colspan => 3}]
          @table.to_s.should == <<-EOS.deindent
            +------+------+------+------+
            |  a   |  bb  | ccc  | dddd |
            +------+------+------+------+
            | aa   | bbb  | cccc | d    |
            | aaa  | bbbb | c    | dd   |
            | a    | x                  |
            +------+------+------+------+
            | aaaa | b    | cc   | ddd  |
            +------+------+------+------+
          EOS
        end
        it 'center' do
          @table.rows << ['a', {:value => 'x', :colspan => 3, :align => :center}]
          @table.to_s.should == <<-EOS.deindent
            +------+------+------+------+
            |  a   |  bb  | ccc  | dddd |
            +------+------+------+------+
            | aa   | bbb  | cccc | d    |
            | aaa  | bbbb | c    | dd   |
            | a    |         x          |
            +------+------+------+------+
            | aaaa | b    | cc   | ddd  |
            +------+------+------+------+
          EOS
        end
        it 'right' do
          @table.rows << ['a', {:value => 'x', :colspan => 3, :align => :right}]
          @table.to_s.should == <<-EOS.deindent
            +------+------+------+------+
            |  a   |  bb  | ccc  | dddd |
            +------+------+------+------+
            | aa   | bbb  | cccc | d    |
            | aaa  | bbbb | c    | dd   |
            | a    |                  x |
            +------+------+------+------+
            | aaaa | b    | cc   | ddd  |
            +------+------+------+------+
          EOS
        end
      end
    end
    describe 'first columns spanned by' do
      describe '2 cells aligned to the' do
        it 'left' do
          @table.rows << [{:value => 'x', :colspan => 2}, 'c', 'd']
          @table.to_s.should == <<-EOS.deindent
            +------+------+------+------+
            |  a   |  bb  | ccc  | dddd |
            +------+------+------+------+
            | aa   | bbb  | cccc | d    |
            | aaa  | bbbb | c    | dd   |
            | x           | c    | d    |
            +------+------+------+------+
            | aaaa | b    | cc   | ddd  |
            +------+------+------+------+
          EOS
        end
        it 'center' do
          @table.rows << [{:value => 'x', :colspan => 2, :align => :center}, 'c', 'd']
          @table.to_s.should == <<-EOS.deindent
            +------+------+------+------+
            |  a   |  bb  | ccc  | dddd |
            +------+------+------+------+
            | aa   | bbb  | cccc | d    |
            | aaa  | bbbb | c    | dd   |
            |      x      | c    | d    |
            +------+------+------+------+
            | aaaa | b    | cc   | ddd  |
            +------+------+------+------+
          EOS
        end
        it 'right' do
          @table.rows << [{:value => 'x', :colspan => 2, :align => :right}, 'c', 'd']
          @table.to_s.should == <<-EOS.deindent
            +------+------+------+------+
            |  a   |  bb  | ccc  | dddd |
            +------+------+------+------+
            | aa   | bbb  | cccc | d    |
            | aaa  | bbbb | c    | dd   |
            |           x | c    | d    |
            +------+------+------+------+
            | aaaa | b    | cc   | ddd  |
            +------+------+------+------+
          EOS
        end
      end
      describe '3 cells aligned to the' do
        it 'left' do
          @table.rows << [{:value => 'x', :colspan => 3}, 'd']
          @table.to_s.should == <<-EOS.deindent
            +------+------+------+------+
            |  a   |  bb  | ccc  | dddd |
            +------+------+------+------+
            | aa   | bbb  | cccc | d    |
            | aaa  | bbbb | c    | dd   |
            | x                  | d    |
            +------+------+------+------+
            | aaaa | b    | cc   | ddd  |
            +------+------+------+------+
          EOS
        end
        it 'center' do
          @table.rows << [{:value => 'x', :colspan => 3, :align => :center}, 'd']
          @table.to_s.should == <<-EOS.deindent
            +------+------+------+------+
            |  a   |  bb  | ccc  | dddd |
            +------+------+------+------+
            | aa   | bbb  | cccc | d    |
            | aaa  | bbbb | c    | dd   |
            |         x          | d    |
            +------+------+------+------+
            | aaaa | b    | cc   | ddd  |
            +------+------+------+------+
          EOS
        end
        it 'right' do
          @table.rows << [{:value => 'x', :colspan => 3, :align => :right}, 'd']
          @table.to_s.should == <<-EOS.deindent
            +------+------+------+------+
            |  a   |  bb  | ccc  | dddd |
            +------+------+------+------+
            | aa   | bbb  | cccc | d    |
            | aaa  | bbbb | c    | dd   |
            |                  x | d    |
            +------+------+------+------+
            | aaaa | b    | cc   | ddd  |
            +------+------+------+------+
          EOS
        end
      end
    end
  end

  describe 'should easily allow alignment of' do
    it 'columns' do
      @table.rows[1][2] = {:value => 'c', :align => :center}
      @table.rows << [{:value => 'x', :colspan => 2}, 'c', 'd']
      @table.rows << ['a', 'b', {:value => 'x', :colspan => 2}]
      @table.align_column 2, :right
      @table.align_column 3, :right
      @table.to_s.should == <<-EOS.deindent
        +------+------+------+------+
        |  a   |  bb  | ccc  | dddd |
        +------+------+------+------+
        | aa   |  bbb | cccc | d    |
        | aaa  | bbbb |  c   | dd   |
        | x           |    c | d    |
        | a    |    b | x           |
        +------+------+------+------+
        | aaaa |    b |   cc | ddd  |
        +------+------+------+------+
      EOS
    end
    it 'rows'
    it 'headers'
    it 'footers'
  end
end