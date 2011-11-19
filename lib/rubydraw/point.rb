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
      unless x.is_a?(Numeric) and y.is_a?(Numeric)
        raise RuntimeError "New Point x and y must be a number."
      end
      @x, @y = x, y
    end

    # Returns if this self falls within the given rectangle.
    def inside?(min, max)
      (x.between?(min.x, max.x)) and (y.between?(min.y, max.y))
    end

    # Add this point's x and y positions to other's x and y positions.
    #
    # Example:
    #   # This produces #<Rubydraw::Point:0x1010f1958 @y=10, @x=60>
    #   Rubydraw::Point[10, 20] + Rubydraw::Point[50, -10]
    def +(other)
      Point[self.x + other.x, self.y + other.y]
    end
  end
end