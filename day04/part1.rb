lines = File.readlines('input')
time_re = /\[\d+\-\d+\-\d+ \d+:(\d+)\]/
begin_re = /Guard #(\d+)/
guards = Hash.new { |h, k| h[k] = Hash.new(0) }
start = 0; id = 0
lines.sort.each do |_line|
  min = _line.match(time_re).to_a[1].to_i
  id = _line.match(begin_re).to_a[1].to_i if _line.include? 'begins shift'
  start = min if _line.include? 'falls asleep'
  (start...min).each { |i| guards[id][i] += 1 } if _line.include? 'wakes up'
end
id = guards.max_by { |_, v| v.values.sum }[0]
min = guards[id].max_by { |_, v| v }[0]
puts id * min
