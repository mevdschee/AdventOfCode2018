lines = File.readlines('input')
forward = Hash.new { |h, k| h[k] = [] }
reverse = Hash.new { |h, k| h[k] = [] }
lines.each do |line|
  words = line.split(' ')
  forward[words[1]] << words[7]
  reverse[words[7]] << words[1]
end

results = []
forward.keys.each do |root|
  root = reverse[root].first while reverse[root].count > 0
  results << root unless results.include?(root)
end

order = []
workers = {}
worker_count = 5
seconds_added = 61
time = 0
while results.count > 0 || workers.keys.count > 0
  worker_count.times do
    next unless workers.keys.count < worker_count

    ready = (results - workers.keys).select { |root| (reverse[root] - order).count == 0 }
    if ready.count > 0
      expand = ready.min
      workers[expand] = seconds_added + (expand.ord - 'A'.ord)
    end
  end
  workers.keys.each { |i| workers[i] -= 1 }
  ready = workers.select { |_k, v| v == 0 }.keys
  ready.each do |expand|
    order << expand
    results += forward[expand]
    results.delete(expand)
    workers.delete(expand)
    results.uniq!
  end
  time += 1
end

puts time
