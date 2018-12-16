lines = File.readlines('input')
points = lines.map { |_line| _line.split(',').map(&:to_i) }
max = points.max_by(&:max).max

count = 0
values = (0..max).to_a
values.product(values).each do |c|
  _distance = points.reduce(0) do |total, p|
    total + (p[0] - c[0]).abs + (p[1] - c[1]).abs
  end
  count += 1 if _distance < 10_000
end

puts count
