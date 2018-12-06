lines = File.readlines('input')
points = lines.map { |_line| _line.split(',').map(&:to_i) }
max = points.max_by { |_coords| _coords.max }.max

counts = Hash.new(0)
infinites = Hash.new(0)
values = (0..max).to_a
values.product(values).each do |_c|
  _distances = points.map.with_index do |_p,_i| 
    [_i, (_p[0]-_c[0]).abs + (_p[1]-_c[1]).abs]
  end.to_h
  _distance = _distances.values.min
  _closest = _distances.select { |_,_v| _v==_distance }.keys
  _i = _closest[0]
  counts[_i] += 1 if (_closest.count==1)
  infinites[_i] = -1 if _c[0]==0 || _c[1]==0 || _c[0]==max || _c[1]==max
end

puts counts.merge(infinites).values.max