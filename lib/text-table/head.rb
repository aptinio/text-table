require 'text-table/row'

class Text::Table
  class Head < Row
    def to_s
      [table.separator, super].join
    end

    def align
      :center
    end
  end
end
