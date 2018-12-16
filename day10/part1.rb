lines = File.readlines('input')
points = lines.map { |line| line.scan(/(-?[0-9]+)/).to_a.flatten.map(&:to_i) }

# loop while bbox shrinks
min = (points.max_by { |c| c.map(&:abs).max }.max * 2)**2
time = -1
loop do
  bbox = (0..3).to_a.map { |i| points.max_by { |c| (i < 2 ? -1 : 1) * c[i % 2] }[i % 2] }
  area = (bbox[2] - bbox[0]) * (bbox[3] - bbox[1])
  break if area > min

  min = area
  points.map! { |pn| [pn[0] + pn[2], pn[1] + pn[3], pn[2], pn[3]] }
  time += 1
end

# reverse one step
points.map! { |pn| [pn[0] - pn[2], pn[1] - pn[3]] }
coords = Hash[points.collect { |point| [point, true] }]
bbox = (0..3).to_a.map { |i| points.max_by { |c| (i < 2 ? -1 : 1) * c[i % 2] }[i % 2] }

# find letters
field = []
(bbox[1]..bbox[3]).each do |y|
  str = '.'
  (bbox[0]..bbox[2]).each do |x|
    str += (coords[[x, y]] ? '#' : '.')
  end
  field << str + '.'
end

alphabet = [
  '...##....#####....####...#####...######..######...####...#....#..######.....###..#....#..#.......#....#..#....#...####...#####....####...#####....#####..######..#....#..#....#..#....#..#....#..#....#..######.',
  '..#..#...#....#..#....#..#....#..#.......#.......#....#..#....#....##........#...#...#...#.......##..##..##...#..#....#..#....#..#....#..#....#..#.........##....#....#..#....#..#....#..#....#..#....#.......#.',
  '.#....#..#....#..#.......#....#..#.......#.......#.......#....#....##........#...#..#....#.......##..##..##...#..#....#..#....#..#....#..#....#..#.........##....#....#..#....#..#....#...#..#...#....#.......#.',
  '.#....#..#....#..#.......#....#..#.......#.......#.......#....#....##........#...#.#.....#.......#.##.#..#.#..#..#....#..#....#..#....#..#....#..#.........##....#....#..#....#..#....#...#..#....#..#.......#..',
  '.#....#..#####...#.......#....#..#####...#####...#.......######....##........#...##......#.......#.##.#..#.#..#..#....#..#####...#....#..#####....####.....##....#....#..#....#..#....#....##.....#..#......#...',
  '.######..#....#..#.......#....#..#.......#.......#..###..#....#....##........#...##......#.......#....#..#..#.#..#....#..#.......#....#..#..#.........#....##....#....#...#..#...#.##.#....##......##......#....',
  '.#....#..#....#..#.......#....#..#.......#.......#....#..#....#....##........#...#.#.....#.......#....#..#..#.#..#....#..#.......#....#..#...#........#....##....#....#...#..#...#.##.#...#..#.....##.....#.....',
  '.#....#..#....#..#.......#....#..#.......#.......#....#..#....#....##....#...#...#..#....#.......#....#..#...##..#....#..#.......#..#.#..#...#........#....##....#....#...#..#...##..##...#..#.....##....#......',
  '.#....#..#....#..#....#..#....#..#.......#.......#...##..#....#....##....#...#...#...#...#.......#....#..#...##..#....#..#.......#...##..#....#.......#....##....#....#....##....##..##..#....#....##....#......',
  '.#....#..#####....####...#####...######..#........###.#..#....#..######...###....#....#..######..#....#..#....#...####...#........#####..#....#..#####.....##.....####.....##....#....#..#....#....##....######.'
]

letters = {}
(0...26).each do |i|
  letter = ''
  (0...10).each do |j|
    letter += "\n" + alphabet[j][i * 8, 8]
  end
  letters[letter] = ('A'.ord + i).chr
end

(0...(field[0].length / 8)).each do |i|
  letter = ''
  (0...10).each do |j|
    letter += "\n" + field[j][i * 8, 8]
  end
  if letters[letter]
    print letters[letter]
  else
    puts letter
  end
end

puts
