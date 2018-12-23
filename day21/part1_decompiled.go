package main

import "fmt"

func main() {
	var a int
	var b int
	var c int
	var d int
	var e int
	var f int
	a, b, c, d, e, f = a, b, c, d, e, f
	b = 123
	for {
		b &= 456
		if b == 72 {
			break
		}

	}
	b = 0
	for {
		c = b | 65536
		b = 10605201
		for {
			f = c & 255
			b += f
			b &= 16777215
			b *= 65899
			b &= 16777215
			if 256 > c {
				break
			}

			f = 0
			for {
				e = f + 1
				e *= 256
				if e > c {
					break
				}

				f += 1
			}
			c = f
		}
		//if b == a {
			break
		//}

	}
	fmt.Println(b)
}
