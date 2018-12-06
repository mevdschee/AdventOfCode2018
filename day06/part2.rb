lines = File.readlines('input')
points = []
max = 0
lines.each_with_index do |_line, _point|
  _coords = _line.split(',').map(&:to_i)
  points << _coords
  max = _coords.max if _coords.max>max
end

count = 0
values = (0..max).to_a
values.product(values).each do |_c|
  _distance = points.reduce(0) do |_total,_p| 
    _total + (_p[0]-_c[0]).abs + (_p[1]-_c[1]).abs
  end
  count+=1 if _distance<10000
end

puts count