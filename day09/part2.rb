class DoubleLinkedCircularList
  class Node
    attr_accessor :previous
    attr_accessor :next
    attr_reader   :value
    def initialize(_value)
      @previous = nil
      @next = nil
      @value = _value
    end

    def to_s
      @value.to_s
    end
  end

  def initialize
    @initial = nil
    @current = nil
  end

  def step(count)
    if @current
      count.abs.times do
        @current = if count < 0
                     @current.previous
                   else
                     @current.next
        end
      end
    end
  end

  def insert(value)
    new_node = Node.new(value)
    if @current.nil?
      new_node.previous = new_node
      new_node.next = new_node
    else
      new_node.previous = @current
      new_node.next = @current.next
    end
    new_node.previous.next = new_node
    new_node.next.previous = new_node
    @current = new_node
    @initial = new_node if @initial.nil?
  end

  def delete
    return if @current.nil?

    previous_node = @current.previous
    previous_node.next = @current.next
    @current = if @current == @current.next
                 nil
               else
                 @current.next
               end
  end

  def read
    if @current.nil?
      nil
    else
      @current.value
    end
  end

  def to_s
    str = '['
    node = @initial
    unless node.nil?
      loop do
        str += if node == @current
                 '_' + node.to_s
               else
                 node.to_s
              end
        node = node.next
        break if node == @initial

        str += ','
      end
    end
    str += ']'
    str
  end
end

lines = File.readlines('input')
lines.each do |_line|
  player_count = _line.match(/(\d+) players/).to_a[1].to_i
  last_marble = _line.match(/(\d+) points/).to_a[1].to_i

  marbles = DoubleLinkedCircularList.new
  marbles.insert(0)
  scores = Hash.new(0)
  (1..last_marble * 100).each do |_marble|
    player = (_marble - 1) % player_count
    if _marble % 23 == 0
      marbles.step(-7)
      scores[player] += _marble + marbles.read
      marbles.delete
    else
      marbles.step(1)
      marbles.insert(_marble)
    end
    # puts "#{player + 1} #{marbles}"
  end

  expected = _line.match(/high score is (\d+)/).to_a[1].to_i if _line.include? 'high score is'
  if expected
    score = scores.values.max
    puts "score: #{score}, expected: #{expected}"
    # exit
  end

  puts scores.values.max
end
