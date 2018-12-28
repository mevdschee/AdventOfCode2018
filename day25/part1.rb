require 'set'

def read_points(filename)
  File.readlines(filename).map do |line|
    line.split(',').map(&:to_i)
  end
end

def find_collisions(points, distance)
  Hash.new { |h, k| h[k] = Set.new }.tap do |collisions|
    points.each_with_index do |p1, n1|
      points.each_with_index do |p2, n2|
        d = p1.zip(p2).map { |c1, c2| (c1 - c2).abs }.reduce(:+)
        collisions[n1] << n2 if d <= distance
      end
    end
  end
end

def find_constellations(collisions)
  collisions.values.each do |points1|
    collisions.values_at(*points1).each do |points2|
      points1.merge(points2)
      points2.merge(points1)
    end
  end.uniq
end

points = read_points('input')
collisions = find_collisions(points, 3)
constellations = find_constellations(collisions)
puts constellations.count
