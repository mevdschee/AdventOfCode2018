require 'set'

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
  collisions = Hash.new { |h, k| h[k] = Set.new }
  indices.product(indices) do |point1, point2|
    x1, y1, z1, r1 = points[point1]
    x2, y2, z2, r2 = points[point2]
    collisions[point1] << point2 if (x2 - x1).abs + (y2 - y1).abs + (z2 - z1).abs + (r2 - r1).abs <= distance
  end
  collisions
end

def find_constellations(collisions)
  changed = true
  while changed
    changed = false
    collisions.each do |_, points1|
      points1.to_a.each do |point2|
        points2 = collisions[point2]
        points1_length = points1.length
        points1.merge(points2)
        changed = true if points1_length != points1.length
      end
    end
  end
  collisions.values.uniq
end

points = read_points('input')
collisions = find_collisions(points, 3)
constellations = find_constellations(collisions)
puts constellations.count
