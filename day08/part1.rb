input = IO.read('input').chomp
numbers = input.split(' ').map(&:to_i)

def parse(_numbers)
  node = { meta: [], children: [] }
  child_count = _numbers.shift
  meta_length = _numbers.shift
  child_count.times do
    node[:children] << parse(_numbers)
  end
  node[:meta] = _numbers.shift(meta_length)
  node
end

def collect_meta(_node)
  _node[:meta] + _node[:children].map { |_child| collect_meta(_child) }.flatten
end

root = parse(numbers)
puts collect_meta(root).sum
