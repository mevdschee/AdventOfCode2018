input = IO.read('input').chomp.to_i

size = 300

field = {}
(1..size).each do |_x|
  (1..size).each do |_y|
    rid = _x + 10
    num = (rid * _y + input) * rid
    field[[_x, _y]] = (num / 100) % 10 - 5
  end
end

summed = {}
(1..size).each do |_x|
  col = 0
  (1..size).each do |_y|
    col += field[[_x, _y]]
    left = (summed[[_x - 1, _y]] || 0)
    summed[[_x, _y]] = left + col
  end
end

threads = []
(1..size).each do |_s|
  threads << Thread.new do
    coordinates = (0..size - _s).to_a.product((0..size - _s).to_a)
    Thread.current['max'] = coordinates.map do |_c|
      _x, _y = _c
      sum = (summed[[_x, _y]] || 0) + (summed[[_x + _s, _y + _s]] || 0)
      sum -= (summed[[_x + _s, _y]] || 0) + (summed[[_x, _y + _s]] || 0)
      [[_x + 1, _y + 1, _s], sum]
    end.to_h.max_by { |_k, v| v }
  end
end

threads.each(&:join)

max = threads.max_by { |_t| _t['max'][1] }['max']

puts max[0].join(',')
