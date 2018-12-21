package main

import (
	"fmt"
	"strconv"
	"strings"
	"io/ioutil"
)

func main() {
	file, _ := ioutil.ReadFile("input")
	lines := strings.Split(strings.TrimSpace(string(file)), "\n")

	registers := [...]int{0, 0, 0, 0, 0, 0}
	ipRegister, _ := strconv.Atoi(strings.Split(lines[0], " ")[1])
	ip := 0

	seen := map[int]bool{}
	last := 0
	lines = lines[1:]
	for {
		if ip>=len(lines) {
			break
		}
		registers[ipRegister] = ip

		instruction := strings.Split(lines[ip], " ")

		operation := instruction[0]
		a, _ := strconv.Atoi(instruction[1])
		b, _ := strconv.Atoi(instruction[2])
		c, _ := strconv.Atoi(instruction[3])

		if (ip==28) {
			target := registers[a]
			if _, found :=seen[target]; found {
				break 
			}
			seen[target] = true
			last = target
		}

		switch operation {
		case "addr":
			registers[c] = registers[a] + registers[b]
		case "addi":
			registers[c] = registers[a] + b
		case "mulr":
			registers[c] = registers[a] * registers[b]
		case "muli":
			registers[c] = registers[a] * b
		case "banr":
			registers[c] = registers[a] & registers[b]
		case "bani":
			registers[c] = registers[a] & b
		case "borr":
			registers[c] = registers[a] | registers[b]
		case "bori":
			registers[c] = registers[a] | b
		case "setr":
			registers[c] = registers[a]
		case "seti":
			registers[c] = a
		case "gtir":
			if a > registers[b] {
				registers[c] = 1
			} else {
				registers[c] = 0
			}
		case "gtri":
			if registers[a] > b {
				registers[c] = 1
			} else {
				registers[c] = 0
			}
		case "gtrr":
			if registers[a] > registers[b] {
				registers[c] = 1
			} else {
				registers[c] = 0
			}
		case "eqir":
			if a == registers[b] {
				registers[c] = 1
			} else {
				registers[c] = 0
			}
		case "eqri":
			if registers[a] == b {
				registers[c] = 1
			} else {
				registers[c] = 0
			}
		case "eqrr":
			if registers[a] == registers[b] {
				registers[c] = 1
			} else {
				registers[c] = 0
			}
		default:
			panic("unrecognized operation")
		}	
		ip = registers[ipRegister]
  		ip++
	}
	fmt.Println(last)
}