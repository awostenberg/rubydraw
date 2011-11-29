module Rubydraw
  # Instances of Color are created with four arguments: Red, green,
  # blue, and alpha (see Rubydraw::Color#initialize) The last is 0
  # by default, and all should have values ranging from 0 to 255.
  # Use this to specify colors instead of hex numbers. Each color
  # instance can return its numerical value, but only Rubydraw itself
  # should need it.
  class Color
    # Returns true if all arguments are within the valid RGB color
    # values (0-255).
    def self.in_bounds?(*args)
      args.each {|element|
        if (0..255).include?(element)
          return true
        else
          return false
        end
      }
    end

    # Shorthand new method.
    def self.[](red, green, blue, alpha = 0)
      self.new(red, green, blue, alpha)
    end

    attr_reader(:red, :green, :blue, :alpha)

    # Create a new color with the given red, green, blue, and alpha
    # values. Alpha is 0 by default.
    #
    # TODO: Add other color specs, like HSV or maybe CYMK
    def initialize(red, green, blue, alpha = 255)
      unless self.class.in_bounds?(red, green, blue, alpha)
        raise IndexError, "One or more color values are out of bounds (must be between 0 and 255)"
      end
      @red, @green, @blue, @alpha = red, green, blue, alpha
      calc_num_val
    end

    # Calculate and store the numerical value in @num_val. You shouldn't
    # need this (see Rubydraw::Color.new).
    def calc_num_val
      # Get the hex string for each value.
      hex_alpha = (@alpha.to_s(16)).color_string
      hex_red = (@red.to_s(16)).color_string
      hex_green = (@green.to_s(16)).color_string
      hex_blue = (@blue.to_s(16)).color_string
      # Construct a hex string using the previously determined hex colors.
      # *Note:* it appears that SDL's colors are in the format +BBGGRRAA+.
      color_str = hex_blue + hex_green + hex_red + hex_alpha
      @num_val = color_str.to_i(16)
    end

    # Convert this color to a numerical value, which only makes sense when
    # read as a hex number, e.g. red would be: +0000ff00+.
    #
    # Also see the comments in: Rubydraw::Color#calc_num_val.
    def to_i
      @num_val
    end

    # Returns an Array containing each +rgba+ value.
    #
    # Example:
    #   color = Rubydraw::Color.new(red = 200, green = 60, blue = 5, alpha = 255)
    #   => #<Rubydraw::Color:0x10039cf50 @green=60, @red=200, @alpha=255, @num_val=87869695, @blue=5>
    #   color.to_ary
    #   => [200, 60, 5, 255]
    def to_a
      [@red, @blue, @green, @alpha]
    end

    # Create an SDL::Color equivilent to this Rubydraw::Color.
    def to_sdl
      SDL::Color.new(to_a)
    end


    White = new(255, 255, 255)
    Black = new(0, 0, 0)
    # The primary colors
    Red = new(255, 0, 0)
    Green = new(0, 255, 0)
    Blue = new(0, 0, 255)
    # Secondary colors
    Yellow = new(255, 0, 255)
    Magenta = new(255, 255, 0)
    Cyan = new(0, 255, 255)
  end
end