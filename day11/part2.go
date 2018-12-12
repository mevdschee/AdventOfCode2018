package main

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)

type Result struct {
	x    int
	y    int
	size int
	sum  int
}

func main() {
	file, _ := ioutil.ReadFile("input")
	input, _ := strconv.Atoi(strings.TrimSpace(string(file)))

	size := 300

	field := map[int]int{}
	for x := 1; x <= size; x++ {
		for y := 1; y <= size; y++ {
			rid := x + 10
			num := (rid*y + input) * rid
			field[x*1000+y] = (num/100)%10 - 5
		}
	}

	summed := map[int]int{}
	for x := 1; x <= size; x++ {
		col := 0
		for y := 1; y <= size; y++ {
			col += field[x*1000+y]
			left := 0
			if x > 1 {
				left, _ = summed[(x-1)*1000+y]
			}
			summed[x*1000+y] = left + col
		}
	}

	c := make(chan Result)
	for s := 0; s <= size; s++ {
		go func(summed map[int]int, s int, c chan Result) {
			var result *Result
			for x := 0; x <= size-s; x++ {
				for y := 0; y <= size-s; y++ {
					sum := 0
					if x > 0 && y > 0 {
						sum += summed[x*1000+y] + summed[(x+s)*1000+(y+s)]
						sum -= summed[(x+s)*1000+y] + summed[x*1000+(y+s)]
					}
					if result == nil || sum > result.sum {
						result = &Result{x + 1, y + 1, s, sum}
					}
				}
			}
			c <- *result
		}(summed, s, c)
	}

	var best *Result
	for s := 0; s <= size; s++ {
		res := <-c
		if best == nil || res.sum > best.sum {
			best = &res
		}
	}

	fmt.Printf("%d,%d,%d\n", best.x, best.y, best.size)

}
