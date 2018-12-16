lines = File.readlines('input')
points = lines.map { |line| line.split(',').map(&:to_i) }
max = points.max_by(&:max).max

counts = Hash.new(0)
infinites = Hash.new(0)
values = (0..max).to_a
values.product(values).each do |c|
  distances = points.map.with_index do |p, i|
    [i, (p[0] - c[0]).abs + (p[1] - c[1]).abs]
  end.to_h
  distance = distances.values.min
  closest = distances.select { |_, v| v == distance }.keys
  i = closest[0]
  counts[i] += 1 if closest.count == 1
  infinites[i] = -1 if c[0] == 0 || c[1] == 0 || c[0] == max || c[1] == max
end

puts counts.merge(infinites).values.max
