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
(0..size).each do |_s|
  threads << Thread.new do
    result = nil
    (0..size - _s).each do |_x|
      (0..size - _s).each do |_y|
        sum = 0
        if _x > 0 && _y > 0
          sum += summed[[_x, _y]] + summed[[_x + _s, _y + _s]]
          sum -= summed[[_x + _s, _y]] + summed[[_x, _y + _s]]
        end
        result = [[_x + 1, _y + 1, _s], sum] if result.nil? || sum > result[1]
      end
    end
    Thread.current['result'] = result
  end
end

threads.each(&:join)

best = threads.max_by { |_t| _t['result'][1] }['result']

puts best[0].join(',')
