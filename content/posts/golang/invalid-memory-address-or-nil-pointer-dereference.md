---
title: "Invalid Memory Address or Nil Pointer Dereference"
summary: "Summary here"
draft: true
---

## Overview {#overview}
Example error:
```golang
panic: runtime error: invalid memory address or nil pointer dereference
[signal SIGSEGV: segmentation violation code=0x1 addr=0x0 pc=0x497783]
```

This issue happens when you reference an unassigned (nil) pointer.

## Initial Steps Overview {#initial-steps-overview}

1) [Assign a variable to the pointer](#step-1)

2) [Use a direct reference instead of a pointer](#step-2)

3) [Check for nil assignments being made to pointers](#step-3)

## Detailed Steps {#detailed-steps}

### 1) Assign a variable to the pointer {#step-1}
```golang
type person struct {
	Name string
	Age  int
}

func main() {
	var joey *person
	fmt.Println(joey.Name)
}
```
```
$ go run main.go
panic: runtime error: invalid memory address or nil pointer dereference
[signal SIGSEGV: segmentation violation code=0x1 addr=0x0 pc=0x497783]
```
Here we use the `*` to declare `joey` as a pointer to a variable of type `person`. When trying to access joey.Name, Go will panic when it finds the pointer doesn't currently point to anything (it is a `nil pointer`).


```golang
func main() 
	var aPerson = person{
		Name: "Joey",
		Age:  29,
	}

	var joey *person
	joey = &aPerson

	fmt.Println(joey.Name)
}
```
To solve this, we need to tell the pointer what to point to. Here the variable `aPerson` already exists, and is of type `person`, so we can use the Go `&` operator to get this variable's reference (location in memory) and assign it to the pointer. Importantly, both `joey` and `aPerson` now point to the same variable, and modifications made to either one will also be present on the other.

```golang
func main() 
	var joey *person
	joey = &aPerson

	aPerson.Name = "Pete"

	fmt.Println(joey.Name) // This will print "Pete"!
}
```

### 2) Create a new variable {#step-2}

Depending on your use case it might be better to use a new varaible and skip using a pointer to an existing one. 

```golang
func main() {
	var joey = person{}
	joey.Name = "Joey"
	fmt.Println(joey.Name)
}
```
This creates a new variable of type `person`, assigns it to the name `joey`. We can then access joey.Name to update the name value.
```golang
func main() {
	joey := person{
		Name: "Joey",
		Age:  29,
	}
	fmt.Println(joey.Name)
}
```
This can be further simplified by:
* using Go's quick assignemnt `:=` syntax
* populating the fields of our struct in the same expression

### 3) Check for nil assignments being made to pointers {#step-3}
``` golang
type AnswerObject struct {
	answer bool
	number int
}

func isFortyTwo(number int) (result *AnswerObject) {
	// Returns a pointer to an AnswerObject if the function is called with 42,
	// otherwise returns nil
	if number == 42 {
		answerObject := AnswerObject{true, 42}
		return &answerObject
	} else {
		return nil
	}
}

func main() {
	result := isFortyTwo(12)
	fmt.Println(result.answer)
}
```
Here a variable of type AnswerObject is only created in the event that certain conditions are met. A pointer is returned by the function either way, but the `main()` function is not prepared to handle the `nil` pointer that is returned in the `else` block, which will cause Go to panic. For a simple way to fix this problem as it occurs here, check out  [Solution A](#solution-a).

## Solutions List {#solutions-list}

A) [Initialize an empty struct](#solution-a)

## Solutions Detail {#solutions-detail}

### A) Initialize an empty struct {#solution-a}
```golang
func isFortyTwo(number int) (result *AnswerObject) {
	// Returns a reference to an AnswerObject.
	// If the function is called with 42, sets result.answer to true
	// otherwise returns blank AnswerObject
	answerObject := AnswerObject{}
	if number == 42 {
		answerObject.answer = true
		answerObject.number = 42
	}
	return &answerObject
}

func main() {
	result := isFortyTwo(12)
	fmt.Println(result.answer, result.number)
}
```
This could be done in a number of ways - both inside and outside the function - but a simple solution in this case would be to declare the `answerObject` before any conditions are checked. That way the pointer being returned will reference an empty struct, rather than nothing. 

You might wonder if trying to print the values `.answer` and `.number` of the empty struct would cause a similar error, but these values are actually initialised at their 'zero' values when the struct is instantiated. In this case, the program prints:

```
$ go run main.go
false 0
```

## Check Resolution {#check-resolution}

## Further Steps {#further-steps}

1) [Further Step 1](#further-steps-1)

### Further Step 1 {#further-steps-1}

## Further Information {#further-information}
https://stackoverflow.com/questions/16280176/go-panic-runtime-error-invalid-memory-address-or-nil-pointer-dereference

## Owner {#owner}

[Joey](https://github.com/jabray5)

