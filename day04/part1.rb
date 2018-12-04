lines = File.readlines('input')
# [1518-06-25 23:58] Guard #1069 begins shift
# [1518-07-09 00:47] wakes up
# [1518-10-04 00:46] falls asleep
time_re = /\[\d+\-\d+\-\d+ \d+:(\d+)\]/
begin_re = /Guard #(\d+)/
guards = {}
start = 0
id = 0
lines.each do |_line|
  min = _line.match(time_re).to_a[1].to_i
  if _line.include? 'begins shift'
    id = _line.match(begin_re).to_a[1].to_i
    guards[id] = Hash.new(0) unless guards[id]
  end
  start = min if _line.include? 'falls asleep'
  next unless _line.include? 'wakes up'

  (start...min).each do |i|
    guards[id][i] += 1
  end
end
id = guards.map { |_k, v| [_k, v.values.sum] }.min_by { |_k, v| -v }[0]
min = guards[id].min_by { |_k, v| -v }[0]
puts id * min
