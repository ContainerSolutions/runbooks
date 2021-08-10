---
title: "Assignment to Entry in Nil Map"
summary: "Summary here"
draft: true
---

## Overview {#overview}

Example error:
```
$ go run main.go
panic: assignment to entry in nil map
```
This panic occurs when you fail to initialize a map properly

## Initial Steps Overview {#initial-steps-overview}

1) [Step 1](#step-1)

2) [Another step](#step-2)

## Detailed Steps {#detailed-steps}

### 1) Use 'make' to initialize the map {#step-1}
``` golang
func main() {
	var agesMap map[string]int

	agesMap["Amanda"] = 25

	fmt.Println(agesMap["Amanda"])
}
```
The block of code above specifies the type of map we want (`string: int`), but doesn't actually create a map for us to use. This will cause a panic when we try to access values in the map.

``` golang 
func main() {
	agesMap := make(map[string]int)

	agesMap["Amanda"] = 25

	fmt.Println(agesMap["Amanda"])
}
```
Instead, we can use `make` to initialize a map of the specified type. We're then free to set and retrieve key:value pairs in the map as usual.

### 2) Nested maps {#step-2}
If you are trying to use a map within another map things an be more complicated, but the same principles remain in that `make` is required to initialize a map.
``` golang
func main() {
	myMap := make(map[string]map[string]int)

	myMap["Mammals"] = make(map[string]int)

	myMap["Mammals"]["Cows"] = 10
	myMap["Mammals"]["Dogs"] = 2

	fmt.Println(myMap["Mammals"])
}
```
```
$ go run main.go
map[Cows:10 Dogs:2]
```
This kind of structure may be better realised by using structs - for an example check [Solution A](#solution-a).

## Solutions List {#solutions-list}

A) [Solution](#solution-a)

## Solutions Detail {#solutions-detail}

### Solution using structs {#solution-a}
``` golang
type Zoo struct {
	Mammals []Animal
	Birds   []Animal
}

type Animal struct {
	Name   string
	Number int
}

func main() {
	zoo := Zoo{}
	zoo.Mammals = []Animal{
		{"Cow", 10},
		{"Dog", 2},
	}

	zoo.Birds = []Animal{
		{"Toucan", 5},
		{"Emu", 4},
	}

	fmt.Println(zoo.Mammals)
}
```
Though there are situations where nesting maps is the right way to go, the example given here should (hopefully) be easier to understand, and provides more flexibility and ease of access for this particular use case. As evidences  
```
go run main.go
[{Cow 10} {Dog 2}]
```

## Check Resolution {#check-resolution}

## Further Steps {#further-steps}

1) [Further Step 1](#further-steps-1)

### Further Step 1 {#further-steps-1}

## Further Information {#further-information}

## Owner {#owner}

email

- [Gotcha assignment](https://yourbasic.org/golang/gotcha-assignment-entry-nil-map/)
https://stackoverflow.com/questions/35379378/go-assignment-to-entry-in-nil-map
https://stackoverflow.com/questions/27267900/runtime-error-assignment-to-entry-in-nil-map