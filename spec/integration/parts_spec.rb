require 'integration_helper'

RSpec.describe Text::Table do
  let(:table) { Text::Table.new :rows => rows, :head => head, :foot => foot }
  let(:head) { nil }
  let(:rows) { @rows }
  let(:foot) { nil }
  subject { table.to_s }

  describe 'rows' do
    it { is_expected.to eq(deindent(%q{
      +-----+------+------+----+
      | aa  | bbb  | cccc | d  |
      | aaa | bbbb | c    | dd |
      +-----+------+------+----+
    })) }

    context 'when nothing is passed into the contructor' do
      let(:rows) { nil }

      it 'is an empty array' do
        expect(table.rows).to eq([])
      end
    end

    context 'with unequal number of cells' do
      skip
    end
  end

  describe 'head' do
    let(:head) { @head }

    it { is_expected.to eq(deindent(%q{
      +-----+------+------+------+
      |  a  |  bb  | ccc  | dddd |
      +-----+------+------+------+
      | aa  | bbb  | cccc | d    |
      | aaa | bbbb | c    | dd   |
      +-----+------+------+------+
    })) }
  end

  describe 'foot' do
    let(:foot) { @foot }

    it { is_expected.to eq(deindent(%q{
      +------+------+------+-----+
      | aa   | bbb  | cccc | d   |
      | aaa  | bbbb | c    | dd  |
      +------+------+------+-----+
      | aaaa | b    | cc   | ddd |
      +------+------+------+-----+
    })) }
  end

  describe 'separators' do
    let(:rows) { @rows.insert(1, :separator) }

    it { is_expected.to eq(deindent(%q{
      +-----+------+------+----+
      | aa  | bbb  | cccc | d  |
      +-----+------+------+----+
      | aaa | bbbb | c    | dd |
      +-----+------+------+----+
    })) }
  end
end
