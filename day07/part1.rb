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

ordered = []
while results.count > 0
  ready = results.select { |root| (reverse[root] - ordered).count == 0 }
  expand = ready.min
  ordered << expand
  results.delete(expand)
  results += forward[expand]
end

puts ordered.join('')
