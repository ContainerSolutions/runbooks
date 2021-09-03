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

1) [Check the declaration of the map](#step-1)

## Detailed Steps {#detailed-steps}

### 1) Check the declaration of the map 
If necessary, use the error information to locate the map causing the issue, then find where this map is first declared, which may be as below:
``` golang
func main() {
	var agesMap map[string]int

	agesMap["Amanda"] = 25

	fmt.Println(agesMap["Amanda"])
}
```
The block of code above specifies the kind of map we want (`string: int`), but doesn't actually create a map for us to use. This will cause a panic when we try to assign values to the map. Instead you should use the `make` keyword as outlined in [Solution A](#solution-a). If you are trying to create a series of nested maps (a map similar to a JSON structure, for example), see [Solution B](#solution-b).

## Solutions List {#solutions-list}

A) [Use 'make' to initialize the map](#solution-a)

B) [Nested maps](#solution-b)

## Solutions Detail {#solutions-detail}

### A) Use 'make' to initialize the map {#solution-a}

``` golang 
func main() {
	var agesMap = make(map[string]int)

	agesMap["Amanda"] = 25

	fmt.Println(agesMap["Amanda"])
}
```
Instead, we can use `make` to initialize a map of the specified type. We're then free to set and retrieve key:value pairs in the map as usual.

### B) Nested Maps {#solution-b}
If you are trying to use a map within another map, for example when building JSON-like data, things can become more complicated, but the same principles remain in that `make` is required to initialize a map.
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
For a more convenient way to work with this kind of nested structure see [Further Step 1](#further-steps-1). It may also be worth considering using [Go structs](https://gobyexample.com/structs) or the [Go JSON package](https://blog.golang.org/json).

## Further Steps {#further-steps}
1) [Use composite literals to create map in-line ](#further-steps-1)

### 1) Use composite literals to create map in-line {#further-steps-1}
Using a composite literal we can skip having to use the `make` keyword and reduce the required number of lines of code. 
```golang
func main() {
	myMap := map[string]map[string]int{
		"Reptiles": {
			"Geckos":          5,
			"Bearded Dragons": 2,
		},
		"Amphibians": {
			"Tree Frogs":  10,
			"Salamanders": 4,
		},
	}
	fmt.Println(myMap)
}

```

## Further Information {#further-information}

https://yourbasic.org/golang/gotcha-assignment-entry-nil-map/
https://stackoverflow.com/questions/35379378/go-assignment-to-entry-in-nil-map
https://stackoverflow.com/questions/27267900/runtime-error-assignment-to-entry-in-nil-map

## Owner {#owner}

[Joey](https://github.com/jabray5)

