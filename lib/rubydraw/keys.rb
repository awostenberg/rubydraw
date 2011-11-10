module Rubydraw
  # Keys defines constants which identify with a key integer.
  #
  # Example:
  #
  #   def handle_event(event)
  #     case event
  #       when Rubydraw::Events::KeyPressed
  #         case event.key
  #           when Rubydraw::Keys::KbUp
  #             @y -= 5
  #           when Rubydraw::Keys::KbDown
  #             @y += 5
  #           when Rubydraw::Keys::KbRight
  #             @x += 1
  #           when Rubydraw::Keys::KbLeft
  #             @x -= 1
  #         end
  #   end
  module Keys
    KbUp              = SDL::K_UP
    KbDown            = SDL::K_DOWN
    KbRight           = SDL::K_RIGHT
    KbLeft            = SDL::K_LEFT
	  KbSpace           = SDL::K_SPACE
	  # Letters
    KbA               = SDL::K_a
	  KbB               = SDL::K_b
	  KbC               = SDL::K_c
	  KbD               = SDL::K_d
	  KbE               = SDL::K_e
	  KbF               = SDL::K_f
    KbG               = SDL::K_g
    KbH               = SDL::K_h
    KbI               = SDL::K_i
    KbJ               = SDL::K_j
    KbK               = SDL::K_k
    KbL               = SDL::K_l
    KbM               = SDL::K_m
    KbN               = SDL::K_n
    KbO               = SDL::K_o
    KbP               = SDL::K_p
    KbQ               = SDL::K_q
    KbR               = SDL::K_r
    KbS               = SDL::K_s
    KbT               = SDL::K_t
    KbU               = SDL::K_u
    KbV               = SDL::K_v
    KbW               = SDL::K_w
    KbX               = SDL::K_x
    KbY               = SDL::K_y
    KbZ               = SDL::K_z
    # Numbers
    Kb0               = SDL::K_0
    Kb1               = SDL::K_1
    Kb2               = SDL::K_2
    Kb3               = SDL::K_3
    Kb4               = SDL::K_4
    Kb5               = SDL::K_5
    Kb6               = SDL::K_6
    Kb7               = SDL::K_7
    Kb8               = SDL::K_8
    Kb9               = SDL::K_9
  end
end