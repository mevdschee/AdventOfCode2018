lines = File.readlines('input')
sum = 0
seen = {}
done = false
until done
  lines.each do |_line|
    sum += _line.to_i
    done = true if seen[sum]
    seen[sum] = true
    break if done
  end
end
puts sum
