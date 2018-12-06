lines = File.readlines('input')
points = lines.map { |_line| _line.split(',').map(&:to_i) }
max = points.max_by { |_coords| _coords.max }.max

count = 0
values = (0..max).to_a
values.product(values).each do |_c|
  _distance = points.reduce(0) do |_total,_p| 
    _total + (_p[0]-_c[0]).abs + (_p[1]-_c[1]).abs
  end
  count+=1 if _distance<10000
end

puts count