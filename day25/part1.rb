def read_points(filename)
  lines = File.readlines(filename)
  re = /(-?\d+),(-?\d+),(-?\d+),(-?\d+)/
  points = []
  lines.each do |line|
    x, y, z, r = line.scan(re).to_a[0].map(&:to_i)
    points << [x, y, z, r]
  end
  points
end

def find_collisions(points, distance)
  indices = points.length.times.to_a
  collisions = Hash.new { |h, k| h[k] = Hash.new(false) }
  indices.product(indices) do |point1, point2|
    next if point1 < point2
    x1, y1, z1, r1 = points[point1]
    x2, y2, z2, r2 = points[point2]
    c = if (x2 - x1).abs + (y2 - y1).abs + (z2 - z1).abs + (r2 - r1).abs <= distance
    collisions[point1][point2] = c
    collisions[point2][point1] = c
  end
  collisions
end

def find_constellations(collisions)
  collisions.each do |_, points1|
    points1.keys.each do |point1|
      points2 = collisions[point1]
      points2.keys.each do |point2|
        collisions[point1][point2] ||= collisions[point2][point1]
        collisions[point2][point1] ||= collisions[point1][point2]
      end
    end
  end
  p collisions
end

points = read_points('input')
collisions = find_collisions(points, 3)
constellations = find_constellations(collisions)
puts constellations.count
