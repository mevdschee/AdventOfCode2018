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

	recipes := []byte("37")
	p1 := 0
	p2 := 1

	done := false
	for !done {
		n1 := recipes[p1] - '0'
		n2 := recipes[p2] - '0'
		sum := n1 + n2
		var num []byte
		if sum < 10 {
			num = []byte{sum}
		} else {
			num = []byte{1, sum - 10}
		}
		for _, n := range num {
			recipes = append(recipes, n + '0')
			if len(recipes) > len(input) && bytes.Equal(recipes[len(recipes)-1-len(input):len(recipes)-1], input) {
				done = true
				break
			}
		}
		p1 = (p1 + 1 + int(n1)) % len(recipes)
		p2 = (p2 + 1 + int(n2)) % len(recipes)
	}
	fmt.Println(len(recipes) - len(input) - 1)
}
