class DoublyLinkedCircularList
  attr_reader :length

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
    @head = nil
    @length = 0
  end

  def rotate(steps)
    return self if @head.nil?

    steps.abs.times do
      @head = if steps < 0
                @head.previous
              else
                @head.next
      end
    end
    self
  end

  def append(value)
    node = Node.new(value)
    if @head.nil?
      node.previous = node
      node.next = node
    else
      node.previous = @head
      node.next = @head.next
    end
    node.previous.next = node
    node.next.previous = node
    @head = node
    @length += 1
    self
  end

  def remove
    return self if @head.nil?

    node = @head.previous
    node.next = @head.next
    node.next.previous = node
    @head = if @head == @head.next
              nil
            else
              @head.previous
            end
    @length -= 1
    self
  end

  def read
    if @head.nil?
      nil
    else
      @head.value
    end
  end

  def to_s
    str = '['
    node = @head
    unless node.nil?
      loop do
        node = node.next
        str += node.to_s
        break if node == @head

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

  marbles = DoublyLinkedCircularList.new
  marbles.append(0)
  scores = Hash.new(0)
  (1..last_marble * 100).each do |_marble|
    player = (_marble - 1) % player_count
    if _marble % 23 == 0
      marbles.rotate(-7)
      scores[player] += _marble + marbles.read
      marbles.remove
      marbles.rotate(1)
    else
      marbles.rotate(1)
      marbles.append(_marble)
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
