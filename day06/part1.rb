lines = File.readlines('input')
active = []
passive = []
field = {}
max = 0
lines.each_with_index do |_line, _point|
  _coords = _line.split(',').map(&:to_i)
  active << _coords
  field[_coords] = _point
  max = _coords.max if _coords.max>max
end

while active.length>0 do
  changes = {}
  next_active = []
  active.each do |_coords|
    if _coords[0]<0 || _coords[0]>max || _coords[1]<0 || _coords[1]>max
      passive << _coords
    else
      _point = field[_coords]
      [[0, 1], [1, 0], [0, -1], [-1, 0]].each do |_move|
        _next = [_coords[0] + _move[0], _coords[1] + _move[1]]
        next if field[_next]
        if changes[_next]!=_point
          if changes[_next]
            changes[_next] = -1
          else
            changes[_next] = _point
          end 
        end
        next_active << _next
      end
    end
  end
  active = next_active.uniq
  field.merge!(changes)
end

counts = Hash.new(0)
field.each do |_coords, _point|
  counts[_point] += 1
end

infinites = passive.map { |_coords| field[_coords] }
infinites.uniq.each { |_point| counts[_point]=-1 }

puts counts.values.max