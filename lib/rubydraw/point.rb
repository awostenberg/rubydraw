module Rubydraw
  # Used for specifying x and y positions in one class, instead of by themselves or
  # arrays. Might look like:
  #
  # @image.draw(Point[5, 6])
  class Point
    # Shorthand new method
    def self.[](x, y)
      self.new(x, y)
    end

    attr_accessor(:x, :y)

    # Create a new point with the given +x+ and +y+ positions.
    def initialize(x, y)
      @x, @y = x, y
    end

    # Returns if this self falls within the given rectangle.
    def inside?(rect)
      min = rect.top_left
      max = rect.bottom_right
      (x.between?(min.x, max.x)) and (y.between?(min.y, max.y))
    end

    # Add this point's x and y positions to +other+'s x and y positions.
    #
    # Example:
    #   Point[10, 20] + Point[50, -10]
    #   => #<Rubydraw::Point:0x1010f1958 @y=10, @x=60>
    # This also works:
    #   Point[10, 20] + 5
    #   => #<Rubydraw::Point:0x1010f1958 @y=15, @x=25>
    def +(other)
      if other.is_a?(Numeric)
        ox, oy = other, other
      else
        ox, oy = other.x, other.y
      end
      Point[self.x + ox, self.y + oy]
    end

    # Subtract +other+'s x and y positions from this point's x and y.
    def -(other)
      if other.is_a?(Numeric)
        ox, oy = other, other
      else
        ox, oy = other.x, other.y
      end
      Point[self.x - ox, self.y - oy]
    end

    # Same as Point#- and Point#+, but multiply instead.
    def *(other)
      if other.is_a?(Numeric)
        ox, oy = other, other
      else
        ox, oy = other.x, other.y
      end
      Point[self.x * ox, self.y * oy]
    end

    # Divide.
    def /(other)
      if other.is_a?(Numeric)
        ox, oy = other, other
      else
        ox, oy = other.x, other.y
      end
      Point[self.x / ox, self.y / oy]
    end

    # Two points are equal if both their x and y positions are the same.
    def ==(other)
      result = if other.is_a?(Point)
        @x == other.x and @y == other.y
      else
        false
      end
    end

    def to_a
      [@x, @y]
    end

    def to_s
      "#{@x}, #{y}"
    end
  end
end