class Object
  # Execute the given block on the appearance of an instance of +event+ and pass that
  # instance to the block.
  #
  # Example:
  #    class MyWindow < Rubydraw::Window
  #      def initialize
  #        super(300, 300)
  #        whenever(Rubydraw::Events::QuitRequest) do
  #          puts "Goodbye!"
  #          close
  #        end
  #        whenever(Rubydraw::Events::MouseMove) do |event|
  #          new_pos = event.position
  #          puts "Mouse moved to #{new_pos.x}, #{new_pos.y}.}"
  #        end
  #      end
  #    end
  def register_action(event, window=self, &block)
    # A very simple rule: +window+ must be a window. Therefore, since +window+ is self
    # by default, instances of Rubydraw::Window calling this method don't have to set
    # that parameter.
    unless window.is_a?(Rubydraw::Window)
      raise ArgumentError, "window must be a Rubydraw::Window"
    end
    event_block = window.registered_actions[event]
    # If nobody has registered a block for this event, prepare the way.
    if event_block.nil?
      window.registered_actions[event] = {}
    end
    # Now add the block.
    window.registered_actions[event][self] = block
  end

  alias whenever register_action

  # Adds the ability to remove actions from registered_actions. Useful if, for example,
  # one were to implement a button that only works if it is shown.
  def unregister_action(event, window=self)
    unless window.is_a?(Rubydraw::Window)
      raise ArgumentError, "window must be a Rubydraw::Window"
    end
    window.registered_actions[event].delete(self)
  end

  def window?
    false
  end
end