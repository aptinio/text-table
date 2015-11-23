class Text::Table
  class Column
    attr_reader :width
    attr_accessor :align

    def initialize
      @width = 0
    end

    def update_width(cell)
      @width = [width, cell.value_length].max
    end
  end
end
