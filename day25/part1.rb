require 'set'

def read_points(filename)
  lines = File.readlines(filename)
  points = []
  lines.each do |line|
    points << line.split(',').map(&:to_i)
  end
  points
end

def find_collisions(points, distance)
  indices = points.each_with_index.to_a
  collisions = Hash.new { |h, k| h[k] = Set.new }
  indices.product(indices) do |point1, point2|
    p1 = points[point1]
    p2 = points[point2]
    d = p1.zip(p2).map { |c1, c2| (c1 - c2).abs }.reduce(:+)
    collisions[point1] << point2 if d <= distance
  end
  collisions
end

def find_constellations(collisions)
  collisions.each do |_point1, points1|
    points1.to_a.each do |point2|
      points2 = collisions[point2]
      next if points1 == points2

      points1.merge(points2)
      points2.merge(points1)
    end
  end
  collisions.values.uniq
end

points = read_points('input')
collisions = find_collisions(points, 3)
constellations = find_constellations(collisions)
puts constellations.count
