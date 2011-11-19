module Rubydraw
  # Keys defines constants which identify with a key integer.
  #
  # Example:
  #
  #   def handle_event(event)
  #     case event
  #       when Rubydraw::Events::KeyPressed
  #         case event.key
  #           when Rubydraw::Keys::UpArrow
  #             @y -= 5
  #           when Rubydraw::Keys::DownArrow
  #             @y += 5
  #           when Rubydraw::Keys::RightArrow
  #             @x += 1
  #           when Rubydraw::Keys::LeftArrow
  #             @x -= 1
  #         end
  #   end
  module Key
    UpArrow         = SDL::K_UP
    DownArrow       = SDL::K_DOWN
    RightArrow      = SDL::K_RIGHT
    LeftArrow       = SDL::K_LEFT
	  # Letters
    A               = SDL::K_a
	  B               = SDL::K_b
	  C               = SDL::K_c
	  D               = SDL::K_d
	  E               = SDL::K_e
	  F               = SDL::K_f
    G               = SDL::K_g
    H               = SDL::K_h
    I               = SDL::K_i
    J               = SDL::K_j
    K               = SDL::K_k
    L               = SDL::K_l
    M               = SDL::K_m
    N               = SDL::K_n
    O               = SDL::K_o
    P               = SDL::K_p
    Q               = SDL::K_q
    R               = SDL::K_r
    S               = SDL::K_s
    T               = SDL::K_t
    U               = SDL::K_u
    V               = SDL::K_v
    W               = SDL::K_w
    X               = SDL::K_x
    Y               = SDL::K_y
    Z               = SDL::K_z
    # Numbers
    Num0            = SDL::K_0
    Num1            = SDL::K_1
    Num2            = SDL::K_2
    Num3            = SDL::K_3
    Num4            = SDL::K_4
    Num5            = SDL::K_5
    Num6            = SDL::K_6
    Num7            = SDL::K_7
    Num8            = SDL::K_8
    Num9            = SDL::K_9
    # Shift
    LeftShift       = SDL::K_LSHIFT
    RightShift      = SDL::K_RSHIFT
    # Whitespaces
    Space           = SDL::K_SPACE
    Tab             = SDL::K_TAB
    # Control
    # Alt/option
    LeftAlt         = SDL::K_LALT
    RightAlt        = SDL::K_RALT
    LeftOption      = LeftAlt
    RightOption     = RightAlt
    # Function buttons
    F1              = SDL::K_F1
    F2              = SDL::K_F2
    F3              = SDL::K_F3
    F4              = SDL::K_F4
    F5              = SDL::K_F5
    F6              = SDL::K_F6
    F7              = SDL::K_F7
    F8              = SDL::K_F8
    F9              = SDL::K_F9
    F10             = SDL::K_F10
    F11             = SDL::K_F11
    F12             = SDL::K_F12
    # Other stuff
    Escape          = SDL::K_ESCAPE
    CapsLock        = SDL::K_CAPSLOCK
    Backspace       = SDL::K_BACKSPACE
    Delete          = SDL::K_DELETE

  end
end