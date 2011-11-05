module Rubydraw
  # Usually raised by anything pertaining to drawing things with SDL, or
  # attempting to. Look at the uses to get a better idea.
  class DrawError < RuntimeError
  end
end