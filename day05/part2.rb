input = IO.read('input').chomp
lengths = {}
('a'..'z').each do |_ch|
  characters = input.gsub(/#{_ch}/i, '').split('')
  i = 0
  while i < characters.length - 1
    ch0 = characters[i]
    ch1 = characters[i + 1]
    if ch0 != ch1 && ch0.casecmp(ch1).zero?
      characters.delete_at(i)
      characters.delete_at(i)
      i -= 2
    end
    i += 1
  end
  lengths[_ch] = characters.length
end
puts lengths.values.min
