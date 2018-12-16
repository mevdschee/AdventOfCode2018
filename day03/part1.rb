lines = File.readlines('input')
re = /#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/
claim = Hash.new(0)
lines.each do |line|
  id, dx, dy, sw, sh = line.scan(re).to_a[0].map(&:to_i)
  (dx...(dx + sw)).each do |px|
    (dy...(dy + sh)).each do |py|
      pos = { x: px, y: py }
      claim[pos] += 1
    end
  end
end
puts claim.count { |_, count| count > 1 }
