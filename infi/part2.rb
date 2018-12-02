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
lines.each_index do |_y|
  field[_y] = []
  _line = lines[_y].chomp.split('')
  _line.each_index do |_x|
    field[_y][_x] = tiles[_line[_x].to_sym].clone
  end
end

# find width and height
width = field[0].length
height = field.length

def neighbours(field, _node, width, height)
  neighbours = []
  %i[up down left right].each do |_direction|
    case _direction
    when :left
      _neighbour = { x: _node[:x] - 1, y: _node[:y] }
    when :right
      _neighbour = { x: _node[:x] + 1, y: _node[:y] }
    when :up
      _neighbour = { x: _node[:x], y: _node[:y] - 1 }
    when :down
      _neighbour = { x: _node[:x], y: _node[:y] + 1 }
    end

    next if _neighbour[:x] < 0 || _neighbour[:x] >= width || _neighbour[:y] < 0 || _neighbour[:y] >= height

    case _direction
    when :left
      next if !field[_node[:y]][_node[:x]][:left] || !field[_neighbour[:y]][_neighbour[:x]][:right]
    when :right
      next if !field[_node[:y]][_node[:x]][:right] || !field[_neighbour[:y]][_neighbour[:x]][:left]
    when :up
      next if !field[_node[:y]][_node[:x]][:up] || !field[_neighbour[:y]][_neighbour[:x]][:down]
    when :down
      next if !field[_node[:y]][_node[:x]][:down] || !field[_neighbour[:y]][_neighbour[:x]][:up]
    end

    neighbours << _neighbour
  end
  neighbours
end

def rotate_field(field, distance, _width, _height)
  return field if distance == 0

  index = (distance - 1) % _width

  if index.even?
    field[index] = field[index].rotate(-1)
  else
    field = field.transpose
    field[index] = field[index].rotate(-1)
    field = field.transpose
  end

  field
end

def print_field(field, tiles)
  lookup = tiles.invert
  field.each_index do |_y|
    field[_y].each_index do |_x|
      print lookup[field[_y][_x]]
    end
    puts
  end
end

def print_nodes(nodes)
  puts nodes.join(',')
end

def rotate_nodes(nodes, distance, _width, _height)
  return nodes if distance == 0

  index = (distance - 1) % _width

  nodes.each do |_node|
    if index.even?
      _node[:x] = (_node[:x] + 1) % _width if _node[:y] == index
    else
      _node[:y] = (_node[:y] + 1) % _height if _node[:x] == index
    end
  end

  nodes
end

# flood
distance = 0
_nodes = [{ x: 0, y: 0 }]
_target = { x: width - 1, y: height - 1 }
until _nodes.include?(_target)
  # print_field(field, tiles)
  field = rotate_field(field, distance, width, height)
  # print_field(field, tiles)
  # print_nodes(_nodes)
  _nodes = rotate_nodes(_nodes, distance, width, height)
  # print_nodes(_nodes)
  _next = []
  _nodes.each do |_node|
    neighbours(field, _node, width, height).each do |_neighbour|
      _next << _neighbour unless _next.include?(_neighbour)
    end
  end
  _nodes = _next
  distance += 1
end
puts distance
