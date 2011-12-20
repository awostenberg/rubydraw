module Rubydraw
  # Contains constants for new window flags, such as Fullscreen and Resizable.
  module Flags
    # Collapse +flags+ using a bitwise or (thanks to Rubygame for most of this
    # chunk of code)
    #
    # Example:
    #   Rubydraw::Flags.collapse(0b10, 0b1000, 0b100000)
    #   => 42 #(0b101010)
    def self.collapse(*flags)
      first_mem = flags[0]
      flags = first_mem if first_mem.is_a?(Array)
      flags.inject(0) {|total, num|
        num | total}
    end

    Fullscreen = SDL::FULLSCREEN
    Resizable = SDL::RESIZABLE
  end
end