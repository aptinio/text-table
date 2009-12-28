require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Enumerable do
  before(:each) do
    @arr = [
      [11, 2, 3333],
      [44, 56, 6],
      [7, 888, 99],
    ]
    @hsh = {
      :k  => 'vv',
      :kk =>  'v',
      'k' =>  :vv
    }
  end

  describe Array do
    it "to Text::Table" do
      @arr.to_text_table.to_s.should == <<-EOS.deindent
        +----+-----+------+
        | 11 | 2   | 3333 |
        | 44 | 56  | 6    |
        | 7  | 888 | 99   |
        +----+-----+------+
      EOS
    end

    it "to Text::Table using flat array" do
      [11, 44, 7].to_text_table.to_s.should == <<-EOS.deindent
        +----+
        | 11 |
        | 44 |
        | 7  |
        +----+
      EOS
    end

    it "to Text::Table, setting first row as head" do
      @arr.to_text_table(:first_row_is_head => true).to_s.should == <<-EOS.deindent
        +----+-----+------+
        | 11 |  2  | 3333 |
        +----+-----+------+
        | 44 | 56  | 6    |
        | 7  | 888 | 99   |
        +----+-----+------+
      EOS
    end

    it "to Text::Table, setting last row as foot" do
      @arr.to_text_table(:last_row_is_foot => true).to_s.should == <<-EOS.deindent
        +----+-----+------+
        | 11 | 2   | 3333 |
        | 44 | 56  | 6    |
        +----+-----+------+
        | 7  | 888 | 99   |
        +----+-----+------+
      EOS
    end
  end

  describe Hash do
    it "to Text::Table" do
      @hsh.to_text_table.to_s.should == <<-EOS.deindent
        +----+----+
        | k  | vv |
        | kk | v  |
        | k  | vv |
        +----+----+
      EOS
    end

    it "to Text::Table, setting first row as head" do
      @hsh.to_text_table(:first_row_is_head => true).to_s.should == <<-EOS.deindent
        +----+----+
        | k  | vv |
        +----+----+
        | kk | v  |
        | k  | vv |
        +----+----+
      EOS
    end

    it "to Text::Table, setting last row as foot" do
      @hsh.to_text_table(:last_row_is_foot => true).to_s.should == <<-EOS.deindent
      +----+----+
      | k  | vv |
      | kk | v  |
      +----+----+
      | k  | vv |
      +----+----+
      EOS
    end
  end
end

