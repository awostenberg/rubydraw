module Rubydraw
  # Rubydraw uses an EventQueue to collect SDL events, e.g. mouse movements
  # keystrokes, and window actions. A new EventQueue is automatically created
  # when a Rubydraw::Window is initialized. Every tick, the window asks its
  # event queue (created in Rubydraw::Window#initialize) for the new events
  class EventQueue
    # Get all the new events
    def get_events
      events = []
      until((event = SDL::PollEvent()).nil?)
        events << event
      end
      events
    end
  end
end