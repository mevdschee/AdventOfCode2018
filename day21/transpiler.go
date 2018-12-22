package main

import (
	"fmt"
	"strconv"
	"regexp"
	"strings"
	"io/ioutil"
	"os/exec"
	"os"
	"io"
)

func readLines(filename string) []string {
	file, err := ioutil.ReadFile(filename)
	if err!=nil {
		panic("cant read input file")
	}
	return strings.Split(strings.TrimSpace(string(file)), "\n")
}

func replaceRegisters(lines []string) []string {
	registers := [...]string{"a", "b", "c", "d", "e", "f"}
	ipRegister, _ := strconv.Atoi(strings.Split(lines[0], " ")[1])
	registers[ipRegister] = "i"
	lines = lines[1:]
	
	// pass 1
	for i := range lines {
	
		instruction := strings.Split(lines[i], " ")
		operation := instruction[0]
		a, _ := strconv.Atoi(instruction[1])
		b, _ := strconv.Atoi(instruction[2])
		c, _ := strconv.Atoi(instruction[3])
	
		switch operation {
		case "addr":
			lines[i]=registers[c]+" = "+registers[a]+" + "+registers[b]
		case "addi":
			lines[i]=registers[c]+" = "+registers[a]+" + "+strconv.Itoa(b)
		case "mulr":
			lines[i]=registers[c]+" = "+registers[a]+" * "+registers[b]
		case "muli":
			lines[i]=registers[c]+" = "+registers[a]+" * "+strconv.Itoa(b)
		case "banr":
			lines[i]=registers[c]+" = "+registers[a]+" & "+registers[b]
		case "bani":
			lines[i]=registers[c]+" = "+registers[a]+" & "+strconv.Itoa(b)
		case "borr":
			lines[i]=registers[c]+" = "+registers[a]+" | "+registers[b]
		case "bori":
			lines[i]=registers[c]+" = "+registers[a]+" | "+strconv.Itoa(b)
		case "setr":
			lines[i]=registers[c]+" = "+registers[a]
		case "seti":
			lines[i]=registers[c]+" = "+strconv.Itoa(a)
		case "gtir":
			lines[i]="if "+strconv.Itoa(a)+" > "+registers[b]+" { "+registers[c]+" = 1 } else { "+registers[c]+" = 0 }"
		case "gtri":
			lines[i]="if "+registers[a]+" > "+strconv.Itoa(b)+" { "+registers[c]+" = 1 } else { "+registers[c]+" = 0 }"
		case "gtrr":
			lines[i]="if "+registers[a]+" > "+registers[b]+" { "+registers[c]+" = 1 } else { "+registers[c]+" = 0 }"
		case "eqir":
			lines[i]="if "+strconv.Itoa(a)+" == "+registers[b]+" { "+registers[c]+" = 1 } else { "+registers[c]+" = 0 }"
		case "eqri":
			lines[i]="if "+registers[a]+" == "+strconv.Itoa(b)+" { "+registers[c]+" = 1 } else { "+registers[c]+" = 0 }"
		case "eqrr":
			lines[i]="if "+registers[a]+" == "+registers[b]+" { "+registers[c]+" = 1 } else { "+registers[c]+" = 0 }"
		default:
			panic("unrecognized operation")
		}	
	}
	return lines
}

func addShortNotation(lines []string) []string{
	re := regexp.MustCompile("([a-z]+) = ([a-z0-9]+) ([+*&|]) ([a-z0-9]+)")
	for i := range lines {
		matches := re.FindStringSubmatch(lines[i])
		if len(matches)==0 {
			continue
		}
		if matches[1]==matches[2] {
			lines[i] = matches[1]+matches[3]+"= "+matches[4]
		} else if matches[1]==matches[4] {
			lines[i] = matches[1]+matches[3]+"= "+matches[2]
		}
	}
	return lines
}

func replaceAddresses(lines []string) []string{
	re1 := regexp.MustCompile("([a-z]+)([+*&| ])= ([a-z0-9]+)( ([+*&|]) ([a-z0-9]+))?")
	re2 := regexp.MustCompile(" i")
	for i := range lines {
		matches := re1.FindStringSubmatch(lines[i])
		if len(matches)==0 {
			continue
		}
		lines[i] = re2.ReplaceAllString(lines[i], " "+strconv.Itoa(i))
	}
	return lines
}

func addGotos(lines []string) []string {
	re1 := regexp.MustCompile("i =")
	for i := range lines {
		if !re1.MatchString(lines[i]) {
			continue
		}
		lines[i] = re1.ReplaceAllString(lines[i], "goto")
	}
	re2 := regexp.MustCompile("goto ([0-9]+) ([+*]) ([0-9]+)")
	for i := range lines {
		matches := re2.FindStringSubmatch(lines[i])
		if len(matches)==0 {
			continue
		}
		a, _ := strconv.Atoi(matches[1])
		b, _ := strconv.Atoi(matches[3])
		if matches[2]=="+" {
			lines[i] = "goto "+strconv.Itoa(a+b)
		} else {
			lines[i] = "goto "+strconv.Itoa(a*b)
		}	
	}
	return lines
}

func addRelativeGotos(lines []string) []string {
	re := regexp.MustCompile("i([+*])= ([a-z0-9]+)")
	for i := range lines {
		matches := re.FindStringSubmatch(lines[i])
		if len(matches)==0 {
			continue
		}
		lines[i] = re.ReplaceAllString(lines[i], "goto "+matches[1]+matches[2])
	}
	return lines
}

func addGotoLabels(lines []string) []string {
	re := regexp.MustCompile("goto ([0-9]+)")
	labels := map[int]string{}
	for i := range lines {
		matches := re.FindStringSubmatch(lines[i])
		if len(matches)>0 {
			line, _ := strconv.Atoi(matches[1])
			lines[i] = "goto L"+strconv.Itoa(line+1)
			labels[line+1] = "L"+strconv.Itoa(line+1)+":"
		}
	}
	for i := range lines {
		lines[i] = fmt.Sprintf("%6s %s",labels[i],lines[i])
	}
	return lines
}

func AddForLoops(lines []string) []string {
	// pass 5
	re := regexp.MustCompile("goto ([0-9]+)")
	for i := range lines {
		matches := re.FindStringSubmatch(lines[i])
		if len(matches)==0 {
			continue
		}
		pos,_ := strconv.Atoi(matches[1])
		if pos<i {
			lines[pos]+= "; for {"
			lines[i] = "}"
		} else {
			lines[i] = "break"
		}
	}
	return lines
}


func addIfBlocks(lines []string) []string {
	re := regexp.MustCompile("if ([^{]+) { ([a-z]) = 1 } else { ([a-z]) = 0 }")
	for i := range lines {
		matches := re.FindStringSubmatch(lines[i])
		if len(matches)==0 {
			continue
		}
		condition := matches[1]
		register := matches[2]
		if lines[i+1]!="goto +"+register {
			continue
		}
		negate := false
		jmp := 2
		action := "break"
		if lines[i+2]=="goto +1" {
			negate = true
			jmp = 3
		}
		if lines[i+jmp] == "break" {
			lines[i+jmp] = ""
		} else if lines[i+jmp] == "}" {
			lines[i+jmp] = "}"
		} else {
			action = lines[i+jmp]
			lines[i+jmp] = ""
		}
		lines[i] = "if "+condition+" { "+action+" }"
		lines[i+1] = ""
		if negate {
			lines[i+2] = ""
		}
	}
	return lines
}

func gofmt(source string) {
	subProcess := exec.Command("gofmt")
	stdin, _ := subProcess.StdinPipe()
    subProcess.Stdout = os.Stdout
    subProcess.Stderr = os.Stderr
    subProcess.Start()
	io.WriteString(stdin, source+"\n")
	stdin.Close()
}

func main() {
	lines := readLines("input")
	lines = replaceRegisters(lines)
	lines = addShortNotation(lines)
	lines = replaceAddresses(lines)
	lines = addGotos(lines)
	lines = addRelativeGotos(lines)
	lines = AddForLoops(lines)
	lines = addIfBlocks(lines)
	lines = addGotoLabels(lines)
	source:= "package main\nfunc main() {\n"
	source+= "var a int;var b int;var c int;var d int;var e int;var f int\n"
	source+= "a,b,c,d,e,f = a,b,c,d,e,f\n"
	source+= strings.Join(lines,"\n")
	source+= "}\n"
	gofmt(source)
}	
