require 'integration_helper'

RSpec.describe Text::Table do
  subject { table.to_s }
  let(:table) { Text::Table.new :rows => @rows, :head => @head, :foot => @foot }

  describe 'first column spanned' do
    context '2 cells wide' do
      before do
        @rows << [{ :value => 'x', :colspan => 2, :align => align }, 'c', 'd']
        @rows << [{ :value => 'xxxxxxxxxxxxx', :colspan => 2, :align => align }, 'c', 'd']
      end

      context 'aligned to the left' do
        let(:align) { :left }

        it { is_expected.to eq(deindent(%q{
          +------+--------+------+------+
          |  a   |   bb   | ccc  | dddd |
          +------+--------+------+------+
          | aa   | bbb    | cccc | d    |
          | aaa  | bbbb   | c    | dd   |
          | x             | c    | d    |
          | xxxxxxxxxxxxx | c    | d    |
          +------+--------+------+------+
          | aaaa | b      | cc   | ddd  |
          +------+--------+------+------+
        })) }
      end

      context 'center aligned' do
        let(:align) { :center }

        it { is_expected.to eq(deindent(%q{
          +------+--------+------+------+
          |  a   |   bb   | ccc  | dddd |
          +------+--------+------+------+
          | aa   | bbb    | cccc | d    |
          | aaa  | bbbb   | c    | dd   |
          |       x       | c    | d    |
          | xxxxxxxxxxxxx | c    | d    |
          +------+--------+------+------+
          | aaaa | b      | cc   | ddd  |
          +------+--------+------+------+
        })) }
      end

      context 'aligned to the right' do
        let(:align) { :right }

        it { is_expected.to eq(deindent(%q{
          +------+--------+------+------+
          |  a   |   bb   | ccc  | dddd |
          +------+--------+------+------+
          | aa   | bbb    | cccc | d    |
          | aaa  | bbbb   | c    | dd   |
          |             x | c    | d    |
          | xxxxxxxxxxxxx | c    | d    |
          +------+--------+------+------+
          | aaaa | b      | cc   | ddd  |
          +------+--------+------+------+
        })) }
      end
    end

    context '3 cells wide' do
      before do
        @rows << [{ :value => 'x', :colspan => 3, :align => align }, 'd']
        @rows << [{ :value => 'xxxxxxxxxxxxxxxxxxx', :colspan => 3, :align => align }, 'd']
      end

      context 'aligned to the left' do
        let(:align) { :left }

        it { is_expected.to eq(deindent(%q{
          +------+------+--------+------+
          |  a   |  bb  |  ccc   | dddd |
          +------+------+--------+------+
          | aa   | bbb  | cccc   | d    |
          | aaa  | bbbb | c      | dd   |
          | x                    | d    |
          | xxxxxxxxxxxxxxxxxxx  | d    |
          +------+------+--------+------+
          | aaaa | b    | cc     | ddd  |
          +------+------+--------+------+
        })) }
      end

      context 'center aligned' do
        let(:align) { :center }

        it { is_expected.to eq(deindent(%q{
          +------+------+--------+------+
          |  a   |  bb  |  ccc   | dddd |
          +------+------+--------+------+
          | aa   | bbb  | cccc   | d    |
          | aaa  | bbbb | c      | dd   |
          |          x           | d    |
          | xxxxxxxxxxxxxxxxxxx  | d    |
          +------+------+--------+------+
          | aaaa | b    | cc     | ddd  |
          +------+------+--------+------+
        })) }
      end

      context 'aligned to the right' do
        let(:align) { :right }

        it { is_expected.to eq(deindent(%q{
          +------+------+--------+------+
          |  a   |  bb  |  ccc   | dddd |
          +------+------+--------+------+
          | aa   | bbb  | cccc   | d    |
          | aaa  | bbbb | c      | dd   |
          |                    x | d    |
          |  xxxxxxxxxxxxxxxxxxx | d    |
          +------+------+--------+------+
          | aaaa | b    | cc     | ddd  |
          +------+------+--------+------+
        })) }
      end
    end
  end

  describe 'last column spanned' do
    context '2 cells wide' do
      before do
        @rows << ['a', 'b', { :value => 'x', :colspan => 2, :align => align }]
        @rows << ['a', 'b', { :value => 'xxxxxxxxxxx', :colspan => 2, :align => align }]
      end

      context 'aligned to the left' do
        let(:align) { :left }

        it { is_expected.to eq(deindent(%q{
          +------+------+------+------+
          |  a   |  bb  | ccc  | dddd |
          +------+------+------+------+
          | aa   | bbb  | cccc | d    |
          | aaa  | bbbb | c    | dd   |
          | a    | b    | x           |
          | a    | b    | xxxxxxxxxxx |
          +------+------+------+------+
          | aaaa | b    | cc   | ddd  |
          +------+------+------+------+
        })) }
      end

      context 'center aligned' do
        let(:align) { :center }

        it { is_expected.to eq(deindent(%q{
          +------+------+------+------+
          |  a   |  bb  | ccc  | dddd |
          +------+------+------+------+
          | aa   | bbb  | cccc | d    |
          | aaa  | bbbb | c    | dd   |
          | a    | b    |      x      |
          | a    | b    | xxxxxxxxxxx |
          +------+------+------+------+
          | aaaa | b    | cc   | ddd  |
          +------+------+------+------+
        })) }
      end

      context 'aligned to the right' do
        let(:align) { :right }

        it { is_expected.to eq(deindent(%q{
          +------+------+------+------+
          |  a   |  bb  | ccc  | dddd |
          +------+------+------+------+
          | aa   | bbb  | cccc | d    |
          | aaa  | bbbb | c    | dd   |
          | a    | b    |           x |
          | a    | b    | xxxxxxxxxxx |
          +------+------+------+------+
          | aaaa | b    | cc   | ddd  |
          +------+------+------+------+
        })) }
      end
    end

    context '3 cells wide' do
      before do
        @rows << ['a', { :value => 'x', :colspan => 3, :align => align }]
        @rows << ['a', { :value => 'xxxxxxxxxxxxxxxxxxx', :colspan => 3, :align => align }]
      end

      context 'aligned to the left' do
        let(:align) { :left }

        it { is_expected.to eq(deindent(%q{
          +------+------+------+-------+
          |  a   |  bb  | ccc  | dddd  |
          +------+------+------+-------+
          | aa   | bbb  | cccc | d     |
          | aaa  | bbbb | c    | dd    |
          | a    | x                   |
          | a    | xxxxxxxxxxxxxxxxxxx |
          +------+------+------+-------+
          | aaaa | b    | cc   | ddd   |
          +------+------+------+-------+
        })) }
      end

      context 'center aligned' do
        let(:align) { :center }

        it { is_expected.to eq(deindent(%q{
          +------+------+------+-------+
          |  a   |  bb  | ccc  | dddd  |
          +------+------+------+-------+
          | aa   | bbb  | cccc | d     |
          | aaa  | bbbb | c    | dd    |
          | a    |          x          |
          | a    | xxxxxxxxxxxxxxxxxxx |
          +------+------+------+-------+
          | aaaa | b    | cc   | ddd   |
          +------+------+------+-------+
        })) }
      end

      context 'aligned to the right' do
        let(:align) { :right }

        it { is_expected.to eq(deindent(%q{
          +------+------+------+-------+
          |  a   |  bb  | ccc  | dddd  |
          +------+------+------+-------+
          | aa   | bbb  | cccc | d     |
          | aaa  | bbbb | c    | dd    |
          | a    |                   x |
          | a    | xxxxxxxxxxxxxxxxxxx |
          +------+------+------+-------+
          | aaaa | b    | cc   | ddd   |
          +------+------+------+-------+
        })) }
      end
    end
  end
end
