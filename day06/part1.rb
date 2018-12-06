lines = File.readlines('input.test')
edges = {}
sizes = Hash.new(0)
field = Hash.new(-1)
add = Hash.new(-1)
lines.each_with_index do |_line, _point|
  edges[_point] = [_line.split(',').map(&:to_i)]
end
100.times do |_dist|
  add = {}
  edges.each do |_point, _values|
    _values.each do |_coords|
      next_coords = []
      [[0, 1], [1, 0], [0, -1], [-1, 0]].each do |_move|
        _next = [_coords[0] + _move[0], _coords[1] + _move[1]]
        if add[_next]
          add[_next] = -1
          next
        end
        if field[_next] == -1
          add[_next] = _point
          next_coords << _next
        end
      end
      next if next_coords.empty?

      p field, _point
      sizes[_point] = field.count do |_k, _v|
        _v == _point
      end
      p sizes
    end
  end
  field.merge!(add)
  p field
end
puts sizes.max_by { |_point, _count| _count }[1]
