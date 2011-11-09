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
      # Just creates a new instance of this class by default. Override this if the subclass
      # requires parameters in +initialize,+ like Rubydraw::Events::MouseDown::from_sdl_event.
      def self.from_sdl_event(sdl_event)
        self.new
      end

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

    # A special event class that is called when no Rubydraw event is matched to an
    # SDL event.
    class UnknownEvent < Event
    end

    # Created when a mouse button is down. Note: this event is used for *any* mouse
    # button.
    class MousePressed < Event
      def self.from_sdl_event(sdl_event)
        self.new(sdl_event.x, sdl_event.y, sdl_event.button)
      end

      def self.matching_sdl_event
        SDL::MOUSEBUTTONDOWN
      end

      attr_accessor(:x, :y, :button)

      # Creates a new MousePressed event, specifying where it happened (the x and y pos.)
      # and what button was pressed.
      def initialize(x, y, button)
        @x, @y, @button = x, y, button
      end
    end

    # Created when a mouse button is released. Note: this event is used for *any* mouse
    # button.
    class MouseReleased < Event
      def self.from_sdl_event(sdl_event)
        self.new(sdl_event.x, sdl_event.y, sdl_event.button)
      end

      def self.matching_sdl_event
        SDL::MOUSEBUTTONUP
      end

      attr_accessor(:x, :y, :button)

      # Creates a new MouseReleased event, specifying where it happened (the x and y pos.) and
      # what button was released.
      def initialize(x, y, button)
        @x, @y, @button = x, y, button
      end
    end

    # Created when the mouse is moved.
    class MouseMove < Event
      def self.from_sdl_event(sdl_event)
        self.new(sdl_event.x, sdl_event.y, sdl_event.xrel, sdl_event.yrel)
      end

      def self.matching_sdl_event
        SDL::MOUSEMOTION
      end

      attr_accessor(:x, :y, :relative_x, :relative_y)

      # Create a new MouseMove event with the new mouse position.
      #
      # +x+ and +y+:                     The new position of the cursor.
      #
      # +relative_x+ and +relative_y+:  The relative movement of the cursor since the last tick.
      def initialize(x, y, relative_y, relative_x)
        @x, @y, @relative_x, @relative_y = x, y, relative_x, relative_y
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
      event_classes.each { |event| rubydraw_event = event.from_sdl_event(sdl_event) if event.matches?(sdl_event_type) }
      rubydraw_event
    end
  end
end