lines = File.readlines('input')
time_re = /\[\d+\-\d+\-\d+ \d+:(\d+)\]/
begin_re = /Guard #(\d+)/
guards = {}; start = 0; id = 0
lines.sort.each do |_line|
  min = _line.match(time_re).to_a[1].to_i
  if _line.include? 'begins shift'
    id = _line.match(begin_re).to_a[1].to_i
    guards[id] = Hash.new(0) unless guards[id]
  end
  start = min if _line.include? 'falls asleep'
  next unless _line.include? 'wakes up'
  (start...min).each { |i| guards[id][i] += 1 }
end
id = guards.max_by { |_, v| v.values.max || 0 }[0]
min = guards[id].max_by { |_, v| v }[0]
puts id * min
