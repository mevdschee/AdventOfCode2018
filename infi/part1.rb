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

# flood
distance = 0
_nodes = [{ x: 0, y: 0 }]
_seen = {}
_target = { x: width - 1, y: height - 1 }
until _nodes.include?(_target)
  _next = []
  _nodes.each do |_node|
    _seen[_node] = true
    neighbours(field, _node, width, height).each do |_neighbour|
      _next << _neighbour unless _next.include?(_neighbour) || _seen[_neighbour]
    end
  end
  _nodes = _next
  distance += 1
end
puts distance
