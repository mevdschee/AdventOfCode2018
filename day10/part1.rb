lines = File.readlines('input')
points = lines.map { |_line| _line.scan(/(-?[0-9]+)/).to_a.flatten.map(&:to_i) }

bbox = (0..3).to_a.map { |i| points.max_by { |coords| (i<2?-1:1)*coords[i%2] }[i%2] }
area = (bbox[2]-bbox[0])*(bbox[3]-bbox[1])