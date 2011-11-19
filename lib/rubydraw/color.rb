module Rubydraw
  # Instances of Color are created with four arguments: Red, green,
  # blue, and alpha. The last is 0 by default, and all should have
  # values ranging from 0 to 255. Use this to specify colors instead
  # hex numbers. Each color instance can return its numerical value,
  # but only Rubydraw itself should need it.
  class Color
    #Red = 0x00_00_ff_00
    #Green = 0x00_ff_00_00
    #Blue = 0xff_00_00_00
    #Black = 0x00_00_00_00
    #White = 0xff_ff_ff_00
    attr_reader(:red, :green, :blue, :alpha)

    # Create a new color with the given red, green, blue, and alpha
    # values. Alpha is 0 by default.
    #
    # TODO: Add other color specs, like HSV or maybe (but probably not) CYMK
    def initialize(red, green, blue, alpha = 0)
      @red, @green, @blue, @alpha = red, green, blue, alpha
    end

    # Convert this color to a numerical value. It only makes sense in
    # hexidecimal or binary format; e.g. red would be equal to
    # +0x0000ff00+.
    def to_i
      # Get the hex string for each value.
      hex_alpha = (@alpha.to_s(16)).color_string
      hex_red = (@red.to_s(16)).color_string
      hex_green = (@green.to_s(16)).color_string
      hex_blue = (@blue.to_s(16)).color_string
      # Construct a hex string using the previously determined hex colors.
      # *Note:* it appears that SDL's (or maybe ruby-sdl-ffi's) color
      # is backwards. The order appears to be: +BBGGRRAA+
      color_str = hex_blue + hex_red + hex_green + hex_alpha
      color_str.to_i(16)
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
  end
end