module Rubydraw
  # Lets you access sound files and play them! A bit different then Gosu in
  # that you don't have to specify the window here; just a matter of taste.
  # Otherwise it's mostly the same:
  #
  # Rubydraw::Sound#new:    Creates a new sound with the given file path
  #
  # Rubydraw::Sound#play:   Plays the sound. *Note*: this method exits
  # immediately; it doesn't wait until the sound is finished.
  class Sound
    # Used to specify the volume (from 0 to 1) when this sound is played.
    # Set at 1 by default
    attr_accessor(:volume)
    # Create a new sound with the given file path. Raise an SDLError if for
    # some reason it couln't load the sound.
    def initialize(path)
      # In case program is being run from a different directory,
      # provide the _full_ path. Nothing relative here.
      full_path = File.expand_path path
      SDL::Mixer.OpenAudio(22050, SDL::AUDIO_S16SYS, 2, 1024)
      @sdl_sound = SDL::Mixer::LoadWAV(full_path)
      # Usually happens because the file doesn't exist.
      if @sdl_sound.pointer.null?
        raise SDLError, "Failed to load sound from: #{full_path} because '#{SDL.GetError}'"
      end
      # The default volume. Can be changed with Sound's volume attribute.
      @volume = 1
      # Allocate a new SDL channel all for this sound to use.
      @channel = SDL::Mixer.AllocateChannels(SDL::Mixer.AllocateChannels(-1) + 1) - 1
    end

    # Play this sound, but don't restart it if it's already playing.
    def play
      SDL::Mixer.Volume(@channel, (SDL::Mixer::MAX_VOLUME * @volume).to_i)
      result = SDL::Mixer.PlayChannelTimed(@channel, @sdl_sound, 0, -1)
      raise(SDLError, "Failed to play sound: #{SDL.GetError}") if result == -1
      self
    end

    # Pause the sound so it can be resumed later.
    def pause
      SDL::Mixer.Pause(@channel)
      self
    end

    # Stop the sound. Unlike pause because Sound#play will start from the
    # beginning afterward.
    def stop
      SDL::Mixer.HaltChannel(@channel)
      self
    end

    # Resume the sound from where it was paused.
    def resume
      SDL::Mixer.Resume(@channel)
      self
    end


    # Returns whether or not this sound is paused.
    def paused?
      SDL::Mixer.Paused(@channel) == 1
    end

    # Returns whether or not this sound is playing.
    def playing?
      (SDL::Mixer.Playing(@channel) == 1) and not paused?
    end

    # Returns whether or not this sound is stopped.
    def stopped?
      not playing?
    end
  end
end