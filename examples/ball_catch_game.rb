require 'rubygems'
require 'rubydraw'

class GameWindow < Rubydraw::Window
  def initialize
    super(500, 500, Rubydraw::Color::White)
    @score = 0
    @score_text = Rubydraw::Text.new("", Rubydraw::Color::Black)
    @game_objects = []
    # Add a new bucket.
    @game_objects << Bucket.new(self)
    # Spawn a ball.
    spawn_ball
    whenever Rubydraw::Events::QuitRequest do
      close
    end
  end

  # Delete any balls that are at the bottom of the screen, then
  # tick all the game objects.
  def tick
    @game_objects.each {|obj|
      if obj.is_a?(Ball) and obj.at_bottom?
        @game_objects.delete(obj)
      end}
    @score_text.contents = @score.to_s
    @score_text.draw(self, Point[0, 0])
    if @game_objects.size == 1
      spawn_ball
    end
    @game_objects.each {|obj| obj.tick}
  end

  # Spawn a new ball, then let it fall!
  def spawn_ball
    @game_objects << Ball.new(self, Point[rand(@width), -50])
  end

  def bucket
    @game_objects[0]
  end

  # This is called when the user gets a ball into the bucket.
  def scored_with(ball)
    delete(ball)
    spawn_ball
    @score += 1
  end

  # Remove the given object from @game_objects.
  def delete(obj)
    @game_objects.delete(obj)
  end
end

class Bucket
  def initialize(window)
    whenever Rubydraw::Events::KeyPressed, window do |event|
      case event.key
        when Rubydraw::Key::RightArrow
          @x += 5
        when Rubydraw::Key::LeftArrow
          @x -= 5
      end
    end
    whenever Rubydraw::Events::MousePressed, window do
      puts ball_entry_zone.to_s
    end
    @window = window
    @image = Rubydraw::Image.new("media/bucket.png")
    @x = 0
  end

  def height
    @image.height
  end

  def width
    @image.width
  end

  def tick
    @position = Point[@x, @window.height - height]
    @image.draw(@window, @position)
  end

  # Where balls can enter the bucket.
  def ball_entry_zone
    Rectangle[@position, Point[width, 20]]
  end
end

class Ball
  def initialize(window, positon)
    @window, @position, = window, positon
    @x, @y = @position.x, @position.y
    @image = Rubydraw::Image.new("media/ball.png")
  end

  def tick
    @y += 5
    @position = Point[@x, @y]
    @image.draw(@window, @position)
    if touching_bucket?
      @window.scored_with(self)
    end
  end

  def width
    @image.width
  end

  def height
    @image.height
  end

  def at_bottom?
    @y >= @window.height
  end

  # Returns a point representing the bottom left corner.
  def bottom_left
    Point[@x, @y + height]
  end

  # Returns a point at the bottom right corner.
  def bottom_right
    Point[@x + width, @y + height]
  end

  # Returns true if the bottom of this ball is touching the
  # bucket.
  def touching_bucket?
    offset = Point[0, 20]
    [bottom_left - offset, bottom_right - offset].each {|p|
      if p.inside?(bucket.ball_entry_zone)
        return true
      end}
    false
  end

  def bucket
    @window.bucket
  end
end

GameWindow.new.show