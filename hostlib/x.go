package main33

import "fmt"

const listname = "main.minjust"

func main() {
	for _, u := range "/?#" {
		fmt.Println(u)
	}
}
