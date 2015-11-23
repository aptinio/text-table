require 'text-table/row'

class Text::Table
  class Foot < Row
    def to_s
      [super, table.separator].join
    end
  end
end
