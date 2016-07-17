package main

import (
	"bufio"
	"fmt"
	"hostlib/hostlib"
	"log"
	"os"
)

func prepareString() []string {
	var s []string
	file, err := os.Open("rkn.list")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		s = append(s, scanner.Text())
	}
	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
	return s
}
func main() {
	var out []string
	var set []string
	for _, line1 := range prepareString() {
		set = set[:0]
		set = append(set, line1)
		set = hostlib.ValidHTTPOnly(set)
		set = hostlib.Lower(set)
		set = hostlib.DomainChange(set)
		set = hostlib.RemoveWWW(set)
		for _, value := range set {
			out = append(out, value)
		}
	}
	fmt.Println(out)
}
