require 'integration_helper'

RSpec.describe Text::Table do
  let(:table) {
    args = { rows: @rows, head: @head, foot: @foot }
    args[:horizontal_boundary] = horizontal_boundary if horizontal_boundary
    args[:vertical_boundary] = vertical_boundary if vertical_boundary
    args[:boundary_intersection] = boundary_intersection if boundary_intersection
    args[:horizontal_padding] = horizontal_padding if horizontal_padding
    Text::Table.new(args)
  }
  let(:horizontal_boundary)   { nil }
  let(:vertical_boundary)     { nil }
  let(:boundary_intersection) { nil }
  let(:horizontal_padding) { nil }
  subject { table.to_s }

  describe 'horizontal boundaries' do
    context 'when ":"' do
      let(:horizontal_boundary) { ':' }

      it { is_expected.to eq(deindent(%q{
        +------+------+------+------+
        :  a   :  bb  : ccc  : dddd :
        +------+------+------+------+
        : aa   : bbb  : cccc : d    :
        : aaa  : bbbb : c    : dd   :
        +------+------+------+------+
        : aaaa : b    : cc   : ddd  :
        +------+------+------+------+
      })) }
    end

    context 'when "||" and boundary intersection is "++"' do
      let(:horizontal_boundary) { '||' }
      let(:boundary_intersection) { '++' }

      it { is_expected.to eq(deindent(%q{
        ++------++------++------++------++
        ||  a   ||  bb  || ccc  || dddd ||
        ++------++------++------++------++
        || aa   || bbb  || cccc || d    ||
        || aaa  || bbbb || c    || dd   ||
        ++------++------++------++------++
        || aaaa || b    || cc   || ddd  ||
        ++------++------++------++------++
      })) }

      context 'with spanned cells' do
        before do
          @rows << :separator
          @rows << [{ value: 'x', colspan: 2, align: :right }, 'c', 'd']
        end

        it { is_expected.to eq(deindent(%q{
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
        })) }
      end

    end
  end

  describe 'vertical boundaries when "="' do
    let(:vertical_boundary) { '=' }

    it { is_expected.to eq(deindent(%q{
      +======+======+======+======+
      |  a   |  bb  | ccc  | dddd |
      +======+======+======+======+
      | aa   | bbb  | cccc | d    |
      | aaa  | bbbb | c    | dd   |
      +======+======+======+======+
      | aaaa | b    | cc   | ddd  |
      +======+======+======+======+
    })) }
  end

  describe 'boundary intersections when "*"' do
    let(:boundary_intersection) { '*' }

    it { is_expected.to eq(deindent(%q{
        *------*------*------*------*
        |  a   |  bb  | ccc  | dddd |
        *------*------*------*------*
        | aa   | bbb  | cccc | d    |
        | aaa  | bbbb | c    | dd   |
        *------*------*------*------*
        | aaaa | b    | cc   | ddd  |
        *------*------*------*------*
    })) }
  end

  describe 'horizantal padding when 3 spaces' do
    let(:horizontal_padding) { 3 }

    it { is_expected.to eq(deindent(%q{
      +----------+----------+----------+----------+
      |    a     |    bb    |   ccc    |   dddd   |
      +----------+----------+----------+----------+
      |   aa     |   bbb    |   cccc   |   d      |
      |   aaa    |   bbbb   |   c      |   dd     |
      +----------+----------+----------+----------+
      |   aaaa   |   b      |   cc     |   ddd    |
      +----------+----------+----------+----------+
    })) }
  end
end
