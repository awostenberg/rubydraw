# The only dependency
require 'ruby-sdl-ffi'

# The extentions must be loaded first, except for +aliases.rb+
require 'ext/string'
require 'ext/object'

# Require all the rubydraw files
files = %w[
  window
  image
  sound
  text
  events
  event_queue
  keys
  point
  color
  sdl_error
  rectangle]
files.each { |f| require("rubydraw/" + f) }

# This must be loaded last, because it sets up constants that "point" to Rubydraw classes, hence
# the name "aliases".
require 'ext/aliases'

# Rubydraw is a high level game/graphics library, like Gosu or Rubygame, and is written completely
# in Ruby. Its only dependency is ruby-sdl-ffi, which it uses to access SDL functions. Also, thanks,
# Rubygame, for documenting your code (which, completely by coninsidence, also uses ruby-sdl-ffi),
# otherwise I wouldn't have the slightest idea on how to use the base library's undocumented code!
# You have been very helpful. :)
#
# NOTE: I can't get +ruby-sdl-ffi+ (the library Rubydraw uses to access SDL) to work with +Ruby
# 1.9.2,+ so I don't know if it even does. If it does work, and/or you know how to make it work,
# I would appreciate it if you notify me. So basically, I can't test anything with +1.9.2+. Sorry
# for the inconvenience!
module Rubydraw
  # Basically just an alias to Rubydraw::Rectangle.
  Rect = Rectangle

  # Initialize SDL.
  def self.initialize_sdl
    if SDL::Init(SDL::INIT_EVERYTHING) != 0
      raise SDLError "Failed to initialize SDL: #{SDL.GetError}"
    end
    # Initialize fonts.
    if (SDL::TTF.WasInit == 0 and not SDL::TTF.Init == 0)
      raise SDLError "Failed to initialize SDL TTF: #{SDL.GetError}"
    end
  end

  def self.vinfo #:nodoc:
    SDL.GetVideoInfo
  end

  private_class_method :vinfo

  # Returns the screen width.
  def self.screen_width
    vinfo.current_w
  end

  # Returns the screen height.
  def self.screen_height
    vinfo.current_h
  end

  # Returns the screen size.
  def self.screen_dimensions
    Point[screen_width, screen_height]
  end

  # Enable/disable key repeating. After this method is called, instances of Rubydraw::Events::KeyPressed
  # wil be continually created, until the key is released.
  #
  # Couldn't get SDL.EnableKeyRepeat to work, so I implemented my own for the time being. This _should_
  # be temporary, but no guarentees...
  def self.set_key_repeat(new)
    unless new.is_a?(TrueClass) or new.is_a?(FalseClass)
      raise ArgumentError, "'new' must be boolean"
    end
    @@key_repeat = new
  end

  # See Rubydraw.set_key_repeat.
  def self.enable_key_repeat
    set_key_repeat(true)
  end

  # See Rubydraw.set_key_repeat.
  def self.disable_key_repeat
    set_key_repeat(false)
  end

  # Return if +key_repeat+ is enabled or not.
  def self.key_repeat
    @@key_repeat
  end
end

Rubydraw.enable_key_repeat

Rubydraw.initialize_sdl

# Make sure to quit SDL systems when the program terminates.
at_exit {SDL.Quit}