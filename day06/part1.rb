lines = File.readlines('input')
points = []
max = 0
lines.each_with_index do |_line, _point|
  _coords = _line.split(',').map(&:to_i)
  points << _coords
  max = _coords.max if _coords.max>max
end

counts = Hash.new(0)
infinites = Hash.new(0)
values = (0..max).to_a
values.product(values).each do |_c|
  _distances = points.map.with_index do |_p,_i| 
    [_i, (_p[0]-_c[0]).abs + (_p[1]-_c[1]).abs]
  end.to_h
  _distance = _distances.values.min
  _closest = _distances.select { |_,_v| _v==_distance }.keys
  _point = _closest[0]
  counts[_point] += 1 if (_closest.count==1)
  infinites[_point] = -1 if _c[0]==0 || _c[1]==0 || _c[0]==max || _c[1]==max
end

puts counts.merge(infinites).values.max