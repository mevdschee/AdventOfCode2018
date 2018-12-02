lines = File.readlines('input').map(&:chomp)
counts = { 2 => 0, 3 => 0 }
lines.each do |_line|
  counts.each do |_count, _|
    _line.split('').sort.uniq.each do |_char|
      if _line.count(_char) == _count
        counts[_count] += 1
        break
      end
    end
  end
end
puts counts.values.reduce(1, :*)
