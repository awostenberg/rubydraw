module Rubydraw
  # Rubydraw uses an EventQueue to collect SDL events, e.g. mouse movements
  # keystrokes, and window actions. A new EventQueue is automatically created
  # when a Rubydraw::Window is initialized. Every tick, the window asks its
  # event queue (created in Rubydraw::Window#initialize) for the new events
  class EventQueue
    def initialize
      @keys_being_repeated = []
    end
    def key_repeat
      Rubydraw.key_repeat
    end
    # Get all the new events
    def get_events
      events = []
      until ((event = SDL.PollEvent) == nil)
        new_event = Events.match(event)
        if new_event.is_a?(Events::KeyReleased)
          @keys_being_repeated.delete(new_event.key)
        end
        if new_event.is_a?(Events::KeyPressed) and not @keys_being_repeated.include?(new_event.key)
          @keys_being_repeated << new_event.key
        end
        events << new_event
      end
      @keys_being_repeated.each {|num| events << Events::KeyPressed.new(num)}
      events
    end

    def exp_get_events
      events = []
      until((event = SDL::PollEvent()).nil?)
        new_event = Events.match(event)
        events << new_event
        key = new_event.key if new_event.is_a?(Events::KeyboardEvent)
        if new_event.is_a?(Events::KeyReleased) and @keys_being_repeated.include?(key)
          @keys_being_repeated.delete(key)
        end
        # Synthesize each key that is being held.
        @keys_being_repeated.each {|num| events << Events::KeyPressed.new(num)}
        # Start adding keys that are held, and remove keys that are no longer
        # being held (whenever a Events::KeyReleased is created).
        if new_event.is_a?(Events::KeyPressed)
          @keys_being_repeated << key
        end
      end
      puts @keys_being_repeated.size
      events
    end
  end
end