lines = File.readlines('input')
re = /#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/
claim = {}
valid = {}
lines.each do |_line|
  id, dx, dy, sw, sh = _line.scan(re).to_a[0].map(&:to_i)
  valid[id] = true
  (dx...(dx + sw)).each do |px|
    (dy...(dy + sh)).each do |py|
      pos = { x: px, y: py }
      cid = claim[pos]
      if cid
        valid.delete(id)
        valid.delete(cid)
      end
      claim[pos] = id
    end
  end
end
puts valid.keys.first
