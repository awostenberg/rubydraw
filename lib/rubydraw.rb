# The only dependency
require 'ruby-sdl-ffi'

# Require all the rubydraw files
#files = ["window", "image", "sdl_error", "event_queue", "events", "point"]
files = %w[
  window
  image
  sdl_error
  keys
  event_queue
  events
  point]
files.each {|f| require("rubydraw/" + f)}

# Rubydraw is a high level game/graphics library, like Gosu or Rubygame, and is written completely
# in Ruby. Its only dependency is ruby-sdl-ffi, which it uses to access SDL functions.
#
# NOTE: I can't get +ruby-sdl-ffi+ (the library Rubydraw uses to access SDL) to work with +Ruby
# 1.9.2,+ so I don't know if it even does. If it does work, and/or you know how to make it work,
# I would appreciate it if you notify me. So basically, I can't test anything with +1.9.2+. Sorry
# for the inconvenience!
module Rubydraw
  # Initialize SDL.
  def self.initialize_sdl
    if SDL::Init(SDL::INIT_EVERYTHING) != 0
      raise DrawError "Could not initialize SDL"
    end
  end
end

Rubydraw::initialize_sdl