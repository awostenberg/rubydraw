module Rubydraw
  # A Rectangle is defined by the position, width, and height, and knows if a point
  # falls inside it. One good use for this class would be a button (will be implemented
  # in a future version, probably soon)
  class Rectangle
    attr_reader(:dimensions, :position)

    # Shorthand new method
    def self.[](dimensions, position)
      self.new(dimensions, position)
    end

    # Create a new rectangle with the given dimensions and position.
    def initialize(dimensions, position)
      raise ArgumentError, "Rectangle dimensions must be a Point" unless dimensions.is_a?(Rubydraw::Point)
      raise ArgumentError, "Rectangle position must be a Point" unless position.is_a?(Rubydraw::Point)
      @dimensions, @position = dimensions, position
    end

    # Returns the x position for the rectangle
    def x
      @position.x
    end

    # Returns this rectangle's y position
    def y
      @position.y
    end

    # Returns the positon of the top left corner
    alias top_left position

    # Returns a point at the bottom left corner
    def bottom_left
      Point[x, y + height]
    end

    # Returns the point at the top right corner
    def top_right
      Point[x + width, y]
    end

    # Returns the position at the bottom right
    def bottom_right
      Point[x + width, y + height]
    end

    # Returns if the given point is inside this rectangle. See Rubydraw::Point#inside?
    def contains?(point)
      point.inside?(top_left, bottom_right)
    end

    # Returns an SDL::Rectangle equal to this one.
    def to_sdl
      SDL::Rect.new([x, y, width, height])
    end

    # Returns this rectangle's width.
    def width
      @dimensions.x
    end

    # Returns this rectangle's height.
    def height
      @dimensions.y
    end

    # Returns all four corners in this Rectangle.
    def points
      [top_left, top_right, bottom_left, bottom_right]
    end
  end
end