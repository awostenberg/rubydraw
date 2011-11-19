class String
  # Sets the size for this string, but does not modify the string.
  # Appends 0 to the beginning if original is one in legnth. (Used
  # in Rubydraw::Color#to_i)
  def color_string
    new_str = self[0..1]
    if new_str.size == 1
      result = "0" + new_str
    else
      result = new_str
    end
    result
  end
end