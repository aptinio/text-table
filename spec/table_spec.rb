require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Text::Table do
  before(:each) do
    @rows = [
      [11, 2, 3333],
      [44, 56, 6],
      [7, 888, 99],
    ]
    @head = %w( a b c )
    @foot = %w( x y z )
    @table = Text::Table.new :rows => @rows, :head => @head
  end

  it "should accept rows" do
    @table = Text::Table.new :rows => @rows
    @table.rows.should == @rows
  end

  it 'should allow setting of rows inside a block' do
    @table = Text::Table.new do |t|
      t.rows = @rows
    end
    @table.rows.should == @rows
  end

  it 'should accept rows with options' do
    @table = Text::Table.new :rows => @rows, :horizontal_padding => 2
    @table.rows.should == @rows
    @table.horizontal_padding.should == 2
  end

  it 'should allow setting of options inside a block' do
    @table = Text::Table.new do |t|
      t.horizontal_padding = 2
    end
    @table.horizontal_padding.should == 2
  end

  it 'should determine the proper column widths' do
    @table.column_widths.should == [2, 3, 4]
  end

  it 'should render tables with no headings properly' do
    @table = Text::Table.new :rows => @rows
    @table.to_s.should == <<-EOS.deindent
      +----+-----+------+
      | 11 | 2   | 3333 |
      | 44 | 56  | 6    |
      | 7  | 888 | 99   |
      +----+-----+------+
    EOS
  end

  it 'should render tables with headings properly' do
    @table.to_s.should == <<-EOS.deindent
      +----+-----+------+
      | a  | b   | c    |
      +----+-----+------+
      | 11 | 2   | 3333 |
      | 44 | 56  | 6    |
      | 7  | 888 | 99   |
      +----+-----+------+
    EOS
  end

  it 'should render tables with footers properly' do
    @table.foot = @foot
    @table.to_s.should == <<-EOS.deindent
      +----+-----+------+
      | a  | b   | c    |
      +----+-----+------+
      | 11 | 2   | 3333 |
      | 44 | 56  | 6    |
      | 7  | 888 | 99   |
      +----+-----+------+
      | x  | y   | z    |
      +----+-----+------+
    EOS
  end

  it 'should render tables with centered headings properly' do
    @table = Text::Table.new :rows => @rows, :head => [
      {:value => 'a', :align => :center},
      {:value => 'b', :align => :center},
      {:value => 'c', :align => :center},
    ]
    @table.to_s.should == <<-EOS.deindent
      +----+-----+------+
      | a  |  b  |  c   |
      +----+-----+------+
      | 11 | 2   | 3333 |
      | 44 | 56  | 6    |
      | 7  | 888 | 99   |
      +----+-----+------+
    EOS
  end

  it 'should render tables with right-justified headings properly' do
    @table = Text::Table.new :rows => @rows, :head => [
      {:value => 'a', :align => :right},
      {:value => 'b', :align => :right},
      {:value => 'c', :align => :right},
    ]
    @table.to_s.should == <<-EOS.deindent
      +----+-----+------+
      |  a |   b |    c |
      +----+-----+------+
      | 11 | 2   | 3333 |
      | 44 | 56  | 6    |
      | 7  | 888 | 99   |
      +----+-----+------+
    EOS
  end

  it 'should render tables with centered cells properly' do
    @table = Text::Table.new :head => @head, :rows => @rows.map{|row| row.map{|cell| {:value => cell, :align => :center}}}
    @table.to_s.should == <<-EOS.deindent
      +----+-----+------+
      | a  | b   | c    |
      +----+-----+------+
      | 11 |  2  | 3333 |
      | 44 | 56  |  6   |
      | 7  | 888 |  99  |
      +----+-----+------+
    EOS
  end

  it 'should render tables with right-justified cells properly' do
    @table = Text::Table.new :head => @head, :rows => @rows.map{|row| row.map{|cell| {:value => cell, :align => :right}}}
    @table.to_s.should == <<-EOS.deindent
      +----+-----+------+
      | a  | b   | c    |
      +----+-----+------+
      | 11 |   2 | 3333 |
      | 44 |  56 |    6 |
      |  7 | 888 |   99 |
      +----+-----+------+
    EOS
  end

  it 'should render rows with cells spanning 2 columns' do
    @table = Text::Table.new :rows => @rows
    @table.rows << [1, {:value => 2, :colspan => 2}]
    @table.to_s.should == <<-EOS.deindent
      +----+-----+------+
      | 11 | 2   | 3333 |
      | 44 | 56  | 6    |
      | 7  | 888 | 99   |
      | 1  | 2          |
      +----+-----+------+
    EOS
  end

  it 'should render rows with 1st cell spanning 2 columns' do
    @table = Text::Table.new :rows => @rows
    @table.rows << [{:value => 333, :colspan => 2}, 1]
    @table.to_s.should == <<-EOS.deindent
      +----+-----+------+
      | 11 | 2   | 3333 |
      | 44 | 56  | 6    |
      | 7  | 888 | 99   |
      | 333      | 1    |
      +----+-----+------+
    EOS
  end

  it 'should render rows with cells spanning 3 columns' do
    @table = Text::Table.new :rows => @rows
    @table.rows << [{:value => 333, :colspan => 3}]
    @table.to_s.should == <<-EOS.deindent
      +----+-----+------+
      | 11 | 2   | 3333 |
      | 44 | 56  | 6    |
      | 7  | 888 | 99   |
      | 333             |
      +----+-----+------+
    EOS
  end

  it 'should render rows with centered cells spanning 2 columns' do
    @table = Text::Table.new :rows => @rows
    @table.rows << [1, {:value => 2, :colspan => 2, :align => :center}]
    @table.to_s.should == <<-EOS.deindent
      +----+-----+------+
      | 11 | 2   | 3333 |
      | 44 | 56  | 6    |
      | 7  | 888 | 99   |
      | 1  |     2      |
      +----+-----+------+
    EOS
  end

  it 'should render rows with 1st cell spanning 2 columns' do
    @table = Text::Table.new :rows => @rows
    @table.rows << [{:value => 333, :colspan => 2, :align => :center}, 1]
    @table.to_s.should == <<-EOS.deindent
      +----+-----+------+
      | 11 | 2   | 3333 |
      | 44 | 56  | 6    |
      | 7  | 888 | 99   |
      |   333    | 1    |
      +----+-----+------+
    EOS
  end

  it 'should render rows with centered cells spanning 3 columns' do
    @table = Text::Table.new :rows => @rows
    @table.rows << [{:value => 333, :colspan => 3, :align => :center}]
    @table.to_s.should == <<-EOS.deindent
      +----+-----+------+
      | 11 | 2   | 3333 |
      | 44 | 56  | 6    |
      | 7  | 888 | 99   |
      |       333       |
      +----+-----+------+
    EOS
  end

  it 'should render rows with right-justified cells spanning 2 columns' do
    @table = Text::Table.new :rows => @rows
    @table.rows << [1, {:value => 2, :colspan => 2, :align => :right}]
    @table.to_s.should == <<-EOS.deindent
      +----+-----+------+
      | 11 | 2   | 3333 |
      | 44 | 56  | 6    |
      | 7  | 888 | 99   |
      | 1  |          2 |
      +----+-----+------+
    EOS
  end

  it 'should render rows with 1st cell spanning 2 columns' do
    @table = Text::Table.new :rows => @rows
    @table.rows << [{:value => 333, :colspan => 2, :align => :right}, 1]
    @table.to_s.should == <<-EOS.deindent
      +----+-----+------+
      | 11 | 2   | 3333 |
      | 44 | 56  | 6    |
      | 7  | 888 | 99   |
      |      333 | 1    |
      +----+-----+------+
    EOS
  end

  it 'should render rows with right-justified cells spanning 3 columns' do
    @table = Text::Table.new :rows => @rows
    @table.rows << [{:value => 333, :colspan => 3, :align => :right}]
    @table.to_s.should == <<-EOS.deindent
      +----+-----+------+
      | 11 | 2   | 3333 |
      | 44 | 56  | 6    |
      | 7  | 888 | 99   |
      |             333 |
      +----+-----+------+
    EOS
  end

  it "should allow adding of separators between rows" do
    @table = Text::Table.new :rows => @rows
    @table.rows << :separator
    @table.rows << [1, 2, 3]
    @table.rows << :separator
    @table.rows << [{:value => 5, :colspan => 3, :align => :right}]
    @table.to_s.should == <<-EOS.deindent
      +----+-----+------+
      | 11 | 2   | 3333 |
      | 44 | 56  | 6    |
      | 7  | 888 | 99   |
      +----+-----+------+
      | 1  | 2   | 3    |
      +----+-----+------+
      |               5 |
      +----+-----+------+
    EOS
  end

  it 'should render horizontal boundaries correctly' do
    @table.horizontal_boundary = ':'
    @table.to_s.should == <<-EOS.deindent
      +----+-----+------+
      : a  : b   : c    :
      +----+-----+------+
      : 11 : 2   : 3333 :
      : 44 : 56  : 6    :
      : 7  : 888 : 99   :
      +----+-----+------+
    EOS
  end

  it 'should render vertical boundaries correctly' do
    @table.vertical_boundary = '='
    @table.to_s.should == <<-EOS.deindent
      +====+=====+======+
      | a  | b   | c    |
      +====+=====+======+
      | 11 | 2   | 3333 |
      | 44 | 56  | 6    |
      | 7  | 888 | 99   |
      +====+=====+======+
    EOS
  end

  it 'should render boundary interserctions properly' do
    @table.boundary_intersection = '*'
    @table.to_s.should == <<-EOS.deindent
      *----*-----*------*
      | a  | b   | c    |
      *----*-----*------*
      | 11 | 2   | 3333 |
      | 44 | 56  | 6    |
      | 7  | 888 | 99   |
      *----*-----*------*
    EOS
  end

  it 'should render double horizontal boundaries properly' do
    @table.horizontal_boundary = '||'
    @table.boundary_intersection = '**'
    @table.to_s.should == <<-EOS.deindent
      **----**-----**------**
      || a  || b   || c    ||
      **----**-----**------**
      || 11 || 2   || 3333 ||
      || 44 || 56  || 6    ||
      || 7  || 888 || 99   ||
      **----**-----**------**
    EOS
  end

  it 'should render double horizontal boundaries with spanned cells properly' do
    @table.horizontal_boundary = '||'
    @table.boundary_intersection = '**'
    @table.rows << :separator
    @table.rows << [{:value => 2, :colspan => 2, :align => :right}, 1]
    @table.to_s.should == <<-EOS.deindent
      **----**-----**------**
      || a  || b   || c    ||
      **----**-----**------**
      || 11 || 2   || 3333 ||
      || 44 || 56  || 6    ||
      || 7  || 888 || 99   ||
      **----**-----**------**
      ||         2 || 1    ||
      **----**-----**------**
    EOS
  end

end