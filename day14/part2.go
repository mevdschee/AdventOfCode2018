package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"strings"
)

func main() {
	file, _ := ioutil.ReadFile("input")
	input := []byte(strings.TrimSpace(string(file)))
	inputLen := len(input)

	recipes := make([]byte, 1024*1024*1024)
	recipes[0] = '3'
	recipes[1] = '7'
	p1 := 0
	p2 := 1

	pos := 2
	done := false
	for !done {
		n1 := recipes[p1] - '0'
		n2 := recipes[p2] - '0'
		sum := n1 + n2
		var num []byte
		if sum < 10 {
			num = []byte{sum}
		} else {
			num = []byte{sum / 10, sum % 10}
		}
		for _, n := range num {
			recipes[pos] = n + '0'
			pos++
			if pos > inputLen && bytes.Equal(recipes[pos-inputLen-1:pos-1], input) {
				done = true
				break
			}
		}
		p1 = (p1 + 1 + int(n1)) % pos
		p2 = (p2 + 1 + int(n2)) % pos
	}
	fmt.Println(pos - inputLen - 1)
}
