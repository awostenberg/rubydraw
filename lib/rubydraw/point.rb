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
  end
end