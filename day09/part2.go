package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
)

type doublyLinkedCircularListNode struct {
	previous *doublyLinkedCircularListNode
	next *doublyLinkedCircularListNode
	value  interface{}
}

type DoublyLinkedCircularList struct {
	length int
	head *doublyLinkedCircularListNode
}

func NewDoublyLinkedCircularList() *DoublyLinkedCircularList {
	return &DoublyLinkedCircularList{
		length: 0,
		head: nil,
	}
}

func (self *DoublyLinkedCircularList) Rotate(steps int) bool {
	if self.head == nil {
		return false
	}
	count := steps
	if count<0 {
		count *= -1
	}
	for i := 0; i < count; i++ {
		if steps < 0 {
			self.head = self.head.previous
		} else {
			self.head = self.head.next
		}
	}
	return true
}

func (self *DoublyLinkedCircularList) Append(value interface{}) bool {
	node := &doublyLinkedCircularListNode{
		previous: nil,
		next: nil,
		value: value,
	}
	if self.head == nil {
      node.previous = node
      node.next = node
	} else {
      node.previous = self.head
      node.next = self.head.next
	}
	node.previous.next = node
    node.next.previous = node
    self.head = node
    self.length++
	return true
}

func (self *DoublyLinkedCircularList) Remove() bool {
	if self.head == nil {
		return false
	}
    node := self.head.previous
    node.next = self.head.next
    node.next.previous = node
    if self.head == self.head.next {
    	self.head = nil
	} else {
        self.head = self.head.previous
	}
    self.length--
	return true
}

func (self *DoublyLinkedCircularList) Read() interface{} {
	if self.head == nil {
		return nil
	}
	return self.head.value
}

func (self *DoublyLinkedCircularList) Length() interface{} {
	return self.length
}

func (self *DoublyLinkedCircularList) ToString() string {
	str := "["
	if self.head != nil {
		node := self.head
		for {
			node = node.next
			str += fmt.Sprintf("%v",node.value)
			if node == self.head {
				break
			}
			str += ","
		}
	}
	str += "]"
	return str
}

func main() {
	f, _ := os.Open("input")
	defer f.Close()
	s := bufio.NewScanner(f)
	for s.Scan() {
		line := s.Text()
		re1 := regexp.MustCompile("(\\d+) players")
		playerCount,_ := strconv.Atoi(re1.FindStringSubmatch(line)[1])
		re2 := regexp.MustCompile("(\\d+) points")
		lastMarble,_:= strconv.Atoi(re2.FindStringSubmatch(line)[1])

		marbles := NewDoublyLinkedCircularList()
		marbles.Append(0)
		scores := map[int]int{}
		for marble := 1; marble <= lastMarble*100; marble++ {
			player := (marble - 1) % playerCount
			if marble % 23 == 0 {
				marbles.Rotate(-7)
				if _, ok := scores[player]; !ok {
					scores[player] = 0	
				}				
				scores[player] += marble + marbles.Read().(int)
				marbles.Remove()
				marbles.Rotate(1)
			} else {
				marbles.Rotate(1)
				marbles.Append(marble)
			}
		}

		score := 0
		for _, v := range scores { 
			if v>score {
				score = v
			}	
		}

		if strings.Contains(line, "high score is") {
			re3 := regexp.MustCompile("high score is (\\d+)")
			expected,_:= strconv.Atoi(re3.FindStringSubmatch(line)[1])
			fmt.Printf("score: %v, expected: %v\n", score, expected)
		}

		fmt.Printf("%v\n", score)
	}

}