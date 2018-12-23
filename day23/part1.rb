lines = File.readlines('input')
re = /pos=<(-?\d+),(-?\d+),(-?\d+)>, r=(\d+)/
bots = {}
lines.each do |line|
  x, y, z, r = line.scan(re).to_a[0].map(&:to_i)
  bots[[x, y, z]] = r
end

origin, range = bots.max_by { |_, v| v }

def distance(coords1, coords2)
  x1, y1, z1 = coords1
  x2, y2, z2 = coords2
  (x2 - x1).abs + (y2 - y1).abs + (z2 - z1).abs
end

puts bots.select { |coords, _| distance(origin, coords) <= range }.count
