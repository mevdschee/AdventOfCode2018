lines = File.readlines('input')
counts = { 2 => 0, 3 => 0 }
lines.each do |line|
  counts.each do |count, _|
    line.split('').sort.uniq.each do |char|
      if line.count(char) == count
        counts[count] += 1
        break
      end
    end
  end
end
puts counts.values.reduce(1, :*)
