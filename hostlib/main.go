package maicac

import "fmt"

func main() {
	if helloworld() && helloworld2() {
		fmt.Println("hello3")
	}
}

func helloworld2() bool {
	fmt.Println("Hello2")
	return false
}
func helloworld() bool {
	fmt.Println("Hello1")
	return false
}
