class Text::Table
  class Separator < SimpleDelegator
    def to_s
      [
        boundary_intersection,
        columns.values.map { |c|
          vertical_boundary * (c.width + 2 * horizontal_padding)
        }.join(boundary_intersection),
        boundary_intersection,
      ].join + "\n"
    end
  end
end
