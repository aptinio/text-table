require 'integration_helper'

RSpec.describe Text::Table do
  let(:table) { Text::Table.new :rows => rows, :head => head, :foot => foot }
  let(:rows) { @rows }
  let(:head) { @head }
  let(:foot) { @foot }
  subject { table.to_s }

  describe 'header alignment' do
    let(:head) { @head.map { |heading| { :value => heading, :align => align } } }
    let(:foot) { nil }

    context 'when left' do
      let(:align) { :left }

      it { is_expected.to eq(deindent(%q{
        +-----+------+------+------+
        | a   | bb   | ccc  | dddd |
        +-----+------+------+------+
        | aa  | bbb  | cccc | d    |
        | aaa | bbbb | c    | dd   |
        +-----+------+------+------+
      })) }
    end

    context 'when center' do
      let(:align) { :center }

      it { is_expected.to eq(deindent(%q{
        +-----+------+------+------+
        |  a  |  bb  | ccc  | dddd |
        +-----+------+------+------+
        | aa  | bbb  | cccc | d    |
        | aaa | bbbb | c    | dd   |
        +-----+------+------+------+
      })) }
    end

    context 'when right' do
      let(:align) { :right }

      it { is_expected.to eq(deindent(%q{
        +-----+------+------+------+
        |   a |   bb |  ccc | dddd |
        +-----+------+------+------+
        | aa  | bbb  | cccc | d    |
        | aaa | bbbb | c    | dd   |
        +-----+------+------+------+
      })) }
    end
  end

  describe 'cell alignment' do
    let(:rows) { @rows.map { |row| row.map { |cell| { :value => cell, :align => align } } } }

    context 'when left' do
      let(:align) { :left }

      it { is_expected.to eq(deindent(%q{
        +------+------+------+------+
        |  a   |  bb  | ccc  | dddd |
        +------+------+------+------+
        | aa   | bbb  | cccc | d    |
        | aaa  | bbbb | c    | dd   |
        +------+------+------+------+
        | aaaa | b    | cc   | ddd  |
        +------+------+------+------+
      })) }
    end

    context 'when center' do
      let(:align) { :center }

      it { is_expected.to eq(deindent(%q{
        +------+------+------+------+
        |  a   |  bb  | ccc  | dddd |
        +------+------+------+------+
        |  aa  | bbb  | cccc |  d   |
        | aaa  | bbbb |  c   |  dd  |
        +------+------+------+------+
        | aaaa | b    | cc   | ddd  |
        +------+------+------+------+
      })) }
    end

    context 'when right' do
      let(:align) { :right }

      it { is_expected.to eq(deindent(%q{
        +------+------+------+------+
        |  a   |  bb  | ccc  | dddd |
        +------+------+------+------+
        |   aa |  bbb | cccc |    d |
        |  aaa | bbbb |    c |   dd |
        +------+------+------+------+
        | aaaa | b    | cc   | ddd  |
        +------+------+------+------+
      })) }
    end
  end

  describe 'footer alignment' do
    let(:head) { nil }
    let(:foot) { @foot.map { |footing| { :value => footing, :align => align } } }

    context 'when left' do
      let(:align) { :left }

      it { is_expected.to eq(deindent(%q{
        +------+------+------+-----+
        | aa   | bbb  | cccc | d   |
        | aaa  | bbbb | c    | dd  |
        +------+------+------+-----+
        | aaaa | b    | cc   | ddd |
        +------+------+------+-----+
      })) }
    end

    context 'when center' do
      let(:align) { :center }

      it { is_expected.to eq(deindent(%q{
        +------+------+------+-----+
        | aa   | bbb  | cccc | d   |
        | aaa  | bbbb | c    | dd  |
        +------+------+------+-----+
        | aaaa |  b   |  cc  | ddd |
        +------+------+------+-----+
      })) }
    end

    context 'when right' do
      let(:align) { :right }

      it { is_expected.to eq(deindent(%q{
        +------+------+------+-----+
        | aa   | bbb  | cccc | d   |
        | aaa  | bbbb | c    | dd  |
        +------+------+------+-----+
        | aaaa |    b |   cc | ddd |
        +------+------+------+-----+
      })) }
    end
  end

  describe 'table-wide alignment' do
    context 'of columns' do
      before do
        @rows[1][2] = {:value => 'c', :align => :center}
        @rows << [{:value => 'x', :colspan => 2}, 'c', 'd']
        @rows << :separator
        @rows << ['a', 'b', {:value => 'x', :colspan => 2}]
        table.align_column 2, :right
        table.align_column 3, :right
      end

      it { is_expected.to eq(deindent(%q{
        +------+------+------+------+
        |  a   |  bb  | ccc  | dddd |
        +------+------+------+------+
        | aa   |  bbb | cccc | d    |
        | aaa  | bbbb |  c   | dd   |
        | x           |    c | d    |
        +------+------+------+------+
        | a    |    b | x           |
        +------+------+------+------+
        | aaaa |    b |   cc | ddd  |
        +------+------+------+------+
      })) }
    end

    context 'of rows' do
      skip
    end

    context 'of headers' do
      skip
    end

    context 'of footers' do
      skip
    end
  end
end
