input = IO.read('input').chomp
numbers = input.split(' ').map(&:to_i)

def parse(numbers)
  node = { meta: [], children: [] }
  child_count = numbers.shift
  meta_length = numbers.shift
  child_count.times do
    node[:children] << parse(numbers)
  end
  node[:meta] = numbers.shift(meta_length)
  node
end

def collect_meta(node)
  node[:meta] + node[:children].map { |child| collect_meta(child) }.flatten
end

root = parse(numbers)
puts collect_meta(root).sum
