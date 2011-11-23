module Rubydraw
  # A Rectangle is defined by the position, width, and height, and knows if a point
  # falls inside it. One good use for this class would be a button (will be implemented
  # in a future version, probably soon)
  class Rectangle
    attr_reader(:dimensions, :position)

    # Shorthand new method
    def self.[](position, dimensions)
      self.new(position, dimensions)
    end

    # Create a new rectangle with the given dimensions and position.
    def initialize(position, dimensions)
      #raise ArgumentError, "Rectangle dimensions must be a Point" unless dimensions.is_a?(Rubydraw::Point)
      #raise ArgumentError, "Rectangle position must be a Point" unless position.is_a?(Rubydraw::Point)
      unless position.respond_to?(:x) and position.respond_to?(:y)
        raise ArgumentError, "Expected a Point, got #{position}"
      end
      unless dimensions.respond_to?(:x) and dimensions.respond_to?(:y)
        raise ArgumentError, "Expected a Point, got #{position}"
      end
      @position, @dimensions = position, dimensions
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
      @position + @dimensions
    end

    # Returns if the given point is inside this rectangle. See Rubydraw::Point#inside?
    def contains?(point)
      point.inside?(self)
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

    # Returns a human-readable string, specifying this rectangle.
    def to_s
      d = @dimensions
      ":Rectangle: (position: #{@position.to_s}) (dimensions: #{d.x}x#{d.y}):"
    end
  end
end