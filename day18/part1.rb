@field = {}

def init(filename)
  File.readlines(filename).each_with_index do |line, y|
    line.chomp.split('').each_with_index do |char, x|
      @field[[x, y]] = char
    end
  end
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

def count_characters(characters)
  @field.keys.select do |x, y|
    characters.include?(@field[[x, y]])
  end.count
end

init('input')
10.times do
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
end

puts count_characters('|') * count_characters('#')
