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

summed = {}
(1..size).each do |x|
  col = 0
  (1..size).each do |y|
    col += field[[x, y]]
    left = (summed[[x - 1, y]] || 0)
    summed[[x, y]] = left + col
  end
end

threads = []
(0..size).each do |s|
  threads << Thread.new do
    result = nil
    (0..size - s).each do |x|
      (0..size - s).each do |y|
        sum = 0
        if x > 0 && y > 0
          sum += summed[[x, y]] + summed[[x + s, y + s]]
          sum -= summed[[x + s, y]] + summed[[x, y + s]]
        end
        result = [[x + 1, y + 1, s], sum] if result.nil? || sum > result[1]
      end
    end
    Thread.current['result'] = result
  end
end

threads.each(&:join)

best = threads.max_by { |t| t['result'][1] }['result']

puts best[0].join(',')
