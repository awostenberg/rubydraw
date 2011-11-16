module Rubydraw
  # Lets you access sound files and play them! A bit different then Gosu in
  # that you don't have to specify the window here; just a matter of taste.
  # Otherwise it's mostly the same:
  #
  # Rubydraw::Sound#new:    Creates a new sound with the given file path
  #
  # Rubydraw::Sound#play:   Plays the sound. *Note*: this method exits
  # immediatley; it doesn't wait until the sound is finished.
  class Sound
    attr_accessor(:volume)
    # Create a new sound with the given file path. Raise an SDLError if for
    # some reason it couln't load the sound.
    def initialize(path)
      # In case program is being run from a different directory,
      # provide the _full_ path. Nothing relative here.
      full_path = File.expand_path path
      SDL::Mixer.OpenAudio(22050, SDL::AUDIO_S16SYS, 2, 1024)
      @sdl_sound = SDL::Mixer::LoadWAV(full_path)
      # Ususally happens because the file doesn't exist.
      if @sdl_sound.pointer.null?
        raise SDLError "Failed to load sound from: #{full_path} because '#{SDL.GetError}'"
      end
      @volume = 1
      @channel = -1
    end

    # Play this sound, and restart it if it's already playing.
    def play
      SDL::Mixer.HaltChannel(@channel)
      @channel = SDL::Mixer.GroupAvailable(-1)
      if @channel == -1
        SDL::Mixer.AllocateChannel(SDL::Mixer.AllocateChannel(-1) + 1)
        @channel = SDL::Mixer.GroupAvailible
      end
      SDL::Mixer.Volume(@channel, (SDL::Mixer::MAX_VOLUME * @volume).to_i)
      result = SDL::Mixer.PlayChannelTimed(@channel, @sdl_sound, 0, -1)
      raise(SDLError, "Failed to play sound: #{SDL.GetError}") if result == -1
      self

      #@playing = true
      #SDL::Mixer::FadeInMusicPos(@sdl_sound, 0, 0, 0)
    end
  end
end