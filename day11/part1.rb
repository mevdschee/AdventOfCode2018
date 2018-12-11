input = IO.read('input').chomp.to_i

size = 300

field = {}

coordinates = (1..size).to_a.product((1..size).to_a)

coordinates.each do |c|
  _x, _y = c
  rid = _x + 10
  num = (rid * _y + input) * rid
  n = (num / 100) % 10 - 5
  field[[_x, _y]] = n
end

coordinates = (1..size - 3).to_a.product((1..size - 3).to_a)
square = (0...3).to_a.product((0...3).to_a)

sums = coordinates.map do |c|
  [c, square.map do |d|
    field[[c[0] + d[0], c[1] + d[1]]]
  end.sum]
end

puts sums.max_by { |_k, v| v }[0].join(',')
