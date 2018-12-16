lines = File.readlines('input')
tiles = {
  ║: { up: true, down: true, left: false, right: false },
  ╔: { up: false, down: true, left: false, right: true },
  ╗: { up: false, down: true, left: true, right: false },
  ╠: { up: true, down: true, left: false, right: true },
  ╦: { up: false, down: true, left: true, right: true },
  ╚: { up: true, down: false, left: false, right: true },
  ╝: { up: true, down: false, left: true, right: false },
  ╬: { up: true, down: true, left: true, right: true },
  ╩: { up: true, down: false, left: true, right: true },
  ═: { up: false, down: false, left: true, right: true },
  ╣: { up: true, down: true, left: true, right: false }
}

# fill field with possible directions
field = []
lines.each_index do |y|
  field[y] = []
  line = lines[y].chomp.split('')
  line.each_index do |x|
    field[y][x] = tiles[line[x].to_sym].clone
  end
end

# find width and height
width = field[0].length
height = field.length

# find valid neighbours
def neighbours(field, node, width, height)
  neighbours = []
  %i[up down left right].each do |direction|
    x = node[:x]
    y = node[:y]

    case direction
    when :left
      neighbour = { x: x - 1, y: y }
    when :right
      neighbour = { x: x + 1, y: y }
    when :up
      neighbour = { x: x, y: y - 1 }
    when :down
      neighbour = { x: x, y: y + 1 }
    end

    nx = neighbour[:x]
    ny = neighbour[:y]

    next if nx < 0 || nx >= width || ny < 0 || ny >= height

    case direction
    when :left
      next if !field[y][x][:left] || !field[ny][nx][:right]
    when :right
      next if !field[y][x][:right] || !field[ny][nx][:left]
    when :up
      next if !field[y][x][:up] || !field[ny][nx][:down]
    when :down
      next if !field[y][x][:down] || !field[ny][nx][:up]
    end

    neighbours << neighbour
  end
  neighbours
end

# flood search
distance = 0
nodes = [{ x: 0, y: 0 }]
seen = {}
target = { x: width - 1, y: height - 1 }
until nodes.include?(target)
  results = []
  nodes.each do |node|
    seen[node] = true
    neighbours(field, node, width, height).each do |neighbour|
      results << neighbour unless results.include?(neighbour) || seen[neighbour]
    end
  end
  nodes = results
  distance += 1
end
puts distance
