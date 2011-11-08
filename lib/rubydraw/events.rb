class Object
  # Returns false by default. Is overridden in Rubydraw::Events::Event#is_event?
  def event?
    false
  end
end

class Class
  # Returns all subclasses. Credit goes to http://stackoverflow.com/questions/436159/how-to-get-all-subclasses
  def all_subclasses
    result = []
    ObjectSpace.each_object(Class) { |klass| result << klass if klass < self }
    result
  end
end

module Rubydraw
  # A module containing Rubydraw events and their SDL event "bindings".
  module Events
    # The basic Event class. All events should inherit from this class, otherwise it
    # won't be recognized as an event and therefore will *not* participate in event
    # matching.
    class Event
      # Returns true if this is the overlaying class for the given SDL event.
      def self.matches?(sdl_event)
        sdl_event == matching_sdl_event
      end

      # Returns true for all event objects. Also see Object#event?
      def event?
        true
      end

      # Returns the matching SDL event, override this in subclasses. Returns nil by
      # default.
      def self.matching_sdl_event
        nil
      end
    end

    # A special event class that is called when no Rubydraw event is matched
    # to an SDL event.
    class UnknownEvent < Event
    end

    # Created when a mouse button is down. Note: this event is used for *any* mouse
    # button.
    class MouseDown < Event
      def self.matching_sdl_event
        SDL::MOUSEBUTTONDOWN
      end

      def initialize(x, y, button)
        @x = x
        @y = y
        @button = button
      end

      def x
        @x
      end

      def y
        @y
      end

      def button
        @button
      end
    end

    # Created when a mouse button is released. Note: this event is used for *any* mouse
    # button.
    class MouseUp < Event
      def self.matching_sdl_event
        SDL::MOUSEBUTTONUP
      end

      def initialize(x, y, button)
        @x = x
        @y = y
        @button = button
      end

      def x
        @x
      end

      def y
        @y
      end

      def button
        @button
      end
    end

    # Created when the mouse is moved.
    class MouseMove < Event
      def self.matching_sdl_event
        SDL::MOUSEMOTION
      end

      # Create a new MouseMove event with the new mouse position.
      def initialize(x, y)
      end

      # Returns the new mouse x from when this event was created.
      def x
        @x
      end

      # Returns the new mouse y at the time this event was created.
      def y
        @y
      end
    end

    # Created when the user attempts to close the window.
    class Quit < Event
      def self.matching_sdl_event
        SDL::QUIT
      end
    end

    # Translate the given SDL event to its corresponding Rubydraw event, by asking
    # each event class if it matches the SDL event. No case statements here.
    def self.match(sdl_event)
      sdl_event_type = sdl_event.type
      event_classes = Event.all_subclasses.compact
      rubydraw_event = UnknownEvent.new
      event_classes.each {|event| rubydraw_event = event if event.matches?(sdl_event_type)}
      puts rubydraw_event
      rubydraw_event
    end

    def self.testmatch(sdl_event)
      case sdl_event.type
        when SDL::QUIT
          puts "yay"
      end
      SDL::QuitEvent
    end
  end
end