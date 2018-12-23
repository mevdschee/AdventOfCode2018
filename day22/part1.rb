lines = File.readlines('input')
depth = lines[0].strip.split(': ')[1].to_i
tx, ty = lines[1].strip.split(': ')[1].split(',').map(&:to_i)

erosion = {}
risk = {}

(0..ty).each do |y|
  (0..tx).each do |x|
    geo = if [x, y] == [0, 0] || [x, y] == [tx, ty]
            0
          elsif y == 0
            x * 16_807
          elsif x == 0
            y * 48_271
          else
            erosion[[x - 1, y]] * erosion[[x, y - 1]]
          end
    ero = (geo + depth) % 20_183
    ch = if [x, y] == [0, 0]
           'M'
         elsif [x, y] == [tx, ty]
           'T'
         else
           case ero % 3
           when 0
             '.'
           when 1
             '='
           when 2
             '|'
           end
          end
    # print ch
    erosion[[x, y]] = ero
    risk[[x, y]] = ero % 3
  end
  # puts
end

puts risk.values.sum
