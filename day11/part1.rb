input = IO.read('input').chomp.to_i

size = 300

field = {}
(1..size).each do |x|
  (1..size).each do |y|
    rid = x + 10
    num = (rid * y + input) * rid
    field[[x, y]] = (num / 100) % 10 - 5
  end
end

coordinates = (1..size - 3).to_a.product((1..size - 3).to_a)
square = (0...3).to_a.product((0...3).to_a)

max = coordinates.map do |c|
  [c, square.map do |d|
    field[[c[0] + d[0], c[1] + d[1]]]
  end.reduce(:+)]
end.max_by { |_, v| v }

puts max[0].join(',')
