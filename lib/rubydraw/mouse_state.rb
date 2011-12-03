module Rubydraw
  # An instance of this class is returned every time you call
  # Rubydraw.mouse_state.
  class MouseState
    attr_reader(:button, :position)

    def initialize(button, position)
      @button, @position = button, position
    end

    def x
      @position.x
    end

    def y
      @position.y
    end

    def to_ary
      [@button, x, y]
    end
  end

  # Return the current mouse condition.
  def self.mouse_state
    state = SDL.GetMouseState
    MouseState.new(state[0], Point[state[1], state[2]])
  end
end