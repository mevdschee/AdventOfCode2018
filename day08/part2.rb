input = IO.read('input').chomp
numbers = input.split(' ').map(&:to_i)

def parse(_numbers)
  node = { meta: [], children: [], value: 0 }
  child_count = _numbers.shift
  meta_length = _numbers.shift
  child_count.times do
    node[:children] << parse(_numbers)
  end
  node[:meta] = _numbers.shift(meta_length)
  node[:value] = if child_count == 0
                   node[:meta].sum
                 else
                   node[:meta].reduce(0) do |_t, _i|
                     _t + if node[:children][_i - 1]
                            node[:children][_i - 1][:value]
                          else
                            0
                          end
                   end
                 end
  node
end

root = parse(numbers)
puts root[:value]
