@field = {}

def init(filename)
  field_from_s(IO.read(filename).chomp)
end

def neighbours(ox, oy)
  result = []
  (-1..1).each do |dy|
    (-1..1).each do |dx|
      next unless dx != 0 || dy != 0

      x = ox + dx
      y = oy + dy
      result << [x, y] if @field[[x, y]] != nil
    end
  end
  result
end

def count_neighbours(x, y, c)
  neighbours(x, y).select { |x, y| @field[[x, y]] == c }.count
end

def field_from_s(s)
  s.split("\n").each_with_index do |line, y|
    line.chomp.split('').each_with_index do |char, x|
      @field[[x, y]] = char
    end
  end
end

def field_to_s
  min_x = @field.keys.map(&:first).min
  min_y = @field.keys.map(&:last).min
  max_x = @field.keys.map(&:first).max
  max_y = @field.keys.map(&:last).max
  s = ''
  (min_y..max_y).each do |y|
    (min_x..max_x).each do |x|
      s += @field[[x, y]]
    end
    s += "\n"
  end
  s
end

def count_characters(characters)
  @field.keys.select do |x, y|
    characters.include?(@field[[x, y]])
  end.count
end

index = 0
states = {}
init('input')
loop.with_index do |_, i|
  new_field = {}
  @field.each do |coordinates, char|
    x, y = coordinates
    case char
    when '.'
      char = '|' if count_neighbours(x, y, '|') >= 3
    when '|'
      char = '#' if count_neighbours(x, y, '#') >= 3
    when '#'
      char = '.' if count_neighbours(x, y, '#') < 1 || count_neighbours(x, y, '|') < 1
    end
    new_field[[x, y]] = char
  end
  @field = new_field
  s = field_to_s
  unless states[s].nil?
    loop_start = states[s]
    loop_end = i
    index = loop_start + (1_000_000_000 - loop_start) % (loop_end - loop_start) - 1
    break
  end
  states[s] = i
end

field_from_s(states.invert[index])
puts count_characters('|') * count_characters('#')
