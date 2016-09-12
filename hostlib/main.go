package main

import (
	"bufio"
	"fmt"
	"hostlib/hostlib"
	"log"
	"os"
)

const listname = "rkn.list"

//ParseList reads each line to string slice from path
func ParseList(path string) []string {
	var raw_urls []string
	list, err := os.Open(path)
	if err != nil {
		log.Fatal(err)
	}
	defer list.Close()
	scanner := bufio.NewScanner(list)
	for scanner.Scan() {
		raw_urls = append(raw_urls, scanner.Text())
	}
	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
	return raw_urls
}

func main() {
	var set []string
	strings := hostlib.FullDomainReduce(ParseList(listname))
	var out = make([]string, 0, len(strings))
	for _, rawUrl := range strings {
		set = set[:0]
		set = append(set, rawUrl)
		set = hostlib.ValidHTTPOnly(set)
		set = hostlib.Lower(set)
		set = hostlib.DomainChange(set)
		set = hostlib.RemoveWWW(set)
		set = hostlib.Fqdn(set)
		for _, value := range set {
			out = append(out, value)
		}
	}
	fmt.Println(out)
}
