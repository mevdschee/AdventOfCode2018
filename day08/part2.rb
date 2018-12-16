input = IO.read('input').chomp
numbers = input.split(' ').map(&:to_i)

def parse(numbers)
  node = { meta: [], children: [], value: 0 }
  child_count = numbers.shift
  meta_length = numbers.shift
  child_count.times do
    node[:children] << parse(numbers)
  end
  node[:meta] = numbers.shift(meta_length)
  node[:value] = if child_count == 0
                   node[:meta].sum
                 else
                   node[:meta].reduce(0) do |t, i|
                     t + if node[:children][i - 1]
                           node[:children][i - 1][:value]
                         else
                           0
                          end
                   end
                 end
  node
end

root = parse(numbers)
puts root[:value]
