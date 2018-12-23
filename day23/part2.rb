def read_bots(filename)
  lines = File.readlines(filename)
  re = /pos=<(-?\d+),(-?\d+),(-?\d+)>, r=(\d+)/
  bots = []
  lines.each do |line|
    x, y, z, r = line.scan(re).to_a[0].map(&:to_i)
    bots << [x, y, z, r]
  end
  bots
end

def optimized_combinations(collides, indices, r, index = 0, data = [], i = 0, skipped = 0)
  if index == r
    yield data
    return
  end

  yield nil if skipped > indices.length - r

  return if i == indices.length

  bot2 = indices[i]
  collides_all = data[0...index].reduce(true) do |res, bot1|
    res &&= collides[[bot1, bot2]]
  end

  data[index] = indices[i]

  optimized_combinations(collides, indices, r, index + 1, data, i + 1, skipped) { |v| yield v } if collides_all

  optimized_combinations(collides, indices, r, index, data, i + 1, skipped + 1) { |v| yield v }
end

def fill_collides(bots)
  indices = bots.length.times.to_a
  collides = {}
  indices.product(indices) do |bot1, bot2|
    next unless bot1 < bot2

    x1, y1, z1, r1 = bots[bot1]
    x2, y2, z2, r2 = bots[bot2]
    collides[[bot1, bot2]] = (x2 - x1).abs + (y2 - y1).abs + (z2 - z1).abs <= r1 + r2
  end
  [collides, indices]
end

def find_largest_collision(collides, indices)
  indices.reverse_each do |size|
    optimized_combinations(collides, indices, size) do |collision|
      return collision unless collision.nil?

      break
    end
  end
end

bots = read_bots('input')
collides, indices = fill_collides(bots)
collision = find_largest_collision(collides, indices)

puts collision.map { |b| bots[b][0..2].map(&:abs).sum - bots[b][3] }.max
