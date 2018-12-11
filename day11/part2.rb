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

threads = []
(1..16).each do |_s|
  threads << Thread.new do
    coordinates = (1..size - _s).to_a.product((1..size - _s).to_a)
    square = (0..._s).to_a.product((0..._s).to_a)

    max = coordinates.map do |c|
      [c + [_s], square.map do |d|
        field[[c[0] + d[0], c[1] + d[1]]]
      end.reduce(:+)]
    end.max_by { |_k, v| v }

    Thread.current['max'] = max
  end
end

threads.each(&:join)

max = threads.max_by { |_t| _t['max'][1] }['max']

puts max[0].join(',')
