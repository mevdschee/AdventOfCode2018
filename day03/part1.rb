lines = File.readlines('input')
re = /#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/
claim = {}
lines.each do |_line|
  id, dx, dy, sw, sh = _line.scan(re).to_a[0].map(&:to_i)
  (dx...(dx + sw)).each do |px|
    (dy...(dy + sh)).each do |py|
      pos = { x: px, y: py }
      claim[pos] = 0 unless claim[pos]
      claim[pos] += 1
    end
  end
end
puts claim.count { |_pos, _count| _count > 1 }
