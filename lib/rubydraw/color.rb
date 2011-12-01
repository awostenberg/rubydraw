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
      calc_num_vals
    end

    # Calculate and store the numerical values. You shouldn't need
    # this (see Rubydraw::Color.new).
    def calc_num_vals
      # Get the hex string for each value.
      hex_alpha = (@alpha.to_s(16)).color_string
      hex_red = (@red.to_s(16)).color_string
      hex_green = (@green.to_s(16)).color_string
      hex_blue = (@blue.to_s(16)).color_string
      # Construct a hex string (only compatible with surfaces other than
      # the window) using the previously determined hex colors. Not sure
      # how alpha comes in here yet... I'll figure it out.
      surf_color_string = hex_red + hex_green + hex_blue
      @surface_num_val = surf_color_string.to_i(16)
      # *Note:* SDL's color format for the display is different than other
      # ordinary surfaces. It is: +BBGGRRAA+.
      display_color_string = hex_blue + hex_green + hex_red + hex_alpha
      @display_num_val = display_color_string.to_i(16)
    end

    # Convert this color to a numerical value, which only makes sense when
    # read as a hex number.
    #
    # Also see the comments in: Rubydraw::Color#calc_num_vals.
    def to_i(format)
      if format == :surface or format == :display_fullscreen
        return @surface_num_val
      end
      if format == :display
        return @display_num_val
      end
      raise ArgumentError, "Unrecognized color format \"@{format}\""
    end

    # Returns the complimentary color.
    def invert
      Color.new(255 - @red, 255 - @green, 255 - @blue, @alpha)
    end

    alias complimentary invert
    alias opposite invert
    alias reverse invert

    # Returns an Array containing each +rgba+ value.
    #
    # Example:
    #   color = Rubydraw::Color.new(red = 200, green = 60, blue = 5, alpha = 255)
    #   => #<Rubydraw::Color: (@red: 200, @green: 60, @blue: 5, @alpha: 255)>
    #   color.to_ary
    #   => [200, 60, 5, 255]
    def to_ary
      [@red, @blue, @green, @alpha]
    end

    def to_s
      "#<#{self.class}: (@red: #{@red}, @green: #{@green}, @blue: #{@blue}, @alpha: #{@alpha})>"
    end

    # Create an SDL::Color equivilent to this Rubydraw::Color.
    def to_sdl
      SDL::Color.new(to_ary)
    end

    # Return a new color resulting from mixing this color and +other+ additively.
    def +(other, a=255)
      r = [@red + other.red, 255].min
      g = [@green + other.green, 255].min
      b = [@blue + other.blue, 255].min
      Color.new(r, g, b, a)
    end

    # Return a new color that is the average of this color and +other+.
    def /(other, a=255)
      r = [(@red + other.red) / 2, 255].min
      g = [(@green + other.green) / 2, 255].min
      b = [(@blue + other.blue) / 2, 255].min
      Color.new(r, g, b, a)
    end

    White = new(255, 255, 255)
    Black = new(0, 0, 0)
    # The primary colors
    Red = new(255, 0, 0)
    Green = new(0, 255, 0)
    Blue = new(0, 0, 255)
    # Secondary colors
    Yellow = new(255, 255, 0)
    Magenta = new(255, 0, 255)
    Cyan = new(0, 255, 255)
    # Other colors
    Purple = new(128, 0, 255)
    Orange = new(255, 128, 0)
    Pink = new(255, 0, 128)
    Grey = new(128, 128, 128)
  end
end