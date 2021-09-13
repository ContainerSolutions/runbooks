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

Go uses an asterisk `*` to specify a pointer to a variable, and an ampersand `&` to generate a pointer to a given variable. For example:

* `var p *int` - p is a pointer to a type integer
* `p := &i` - p is a pointer to variable i

## Initial Steps Overview {#initial-steps-overview}

1) [Check if the pointer is being set](#step-1)

2) [Check for a nil assignment to the pointer](#step-2)

## Detailed Steps {#detailed-steps}

### 1) Check if the pointer is being set {#step-1}

Before a pointer can be referenced, it needs to have something assigned to it. 

```golang
type person struct {
	Name string
	Age  int
}

func main() {
	var myPointer *person
	fmt.Println(myPointer.Name)
}
```
```
$ go run main.go
panic: runtime error: invalid memory address or nil pointer dereference
[signal SIGSEGV: segmentation violation code=0x1 addr=0x0 pc=0x497783]
```

The above code causes Go to panic because, while `myPointer` has been declared as a pointer to a `person` object, it currently does not point to a particular instance of such an object. This can be solved by assigning a variable to the pointer [(Solution A)](#solution-a) or by creating and referencing a new object [(Solution B)](#solution-b).

### 2) Check for a nil assignment to the pointer {#step-2}

Another possibility is that the pointer is being set to `nil` somewhere in your code. This could be, for example, a function returning `nil` after failing to accomplish a task.

``` golang
type NumberObject struct {
	number int
}

func createNumberObj(num int) (result *NumberObject) {
	// Returns a pointer to a NumberObject if the number is allowed, otherwise returns nil
	if num < 100 {
		numberObj := NumberObject{num}
		return &numberObj // Returns a reference to the new object
	} else {
		return nil
	}
}

func main() {
	myNumberObject := createNumberObject(101)
	fmt.Println(myNumberObject.number) // This will cause Go to panic!
}
```
Here a `NumberObject` is created only if the input is less than 100. A pointer is returned by the function either way, but the `main()` function is not prepared to handle the `nil` pointer that is returned if the conditions aren't met, causing Go to panic. It would be best to handle this issue by either handling the nil pointer as demonstrated in [Solution B](#solution-b), or by creaing and referencing an empty object as per [Solution C](#solution-c).

## Solutions List {#solutions-list}

A) [Assign a variable to the pointer](#solution-a)

B) [Handle the nil pointer](#solution-b)

C) [Create and reference a new variable](#solution-c)

## Solutions Detail {#solutions-detail}

### A) Assign a variable to the pointer{#solution-a}

```golang
type Person struct{
	Name string
	Age int
}

func main() 
	var myPointer *Person // This is currently a nil pointer

	aPerson := Person{
		Name: "Joey",
		Age:  29,
	} // This is a Person object
	
	myPointer = &aPerson // Now the pointer references the same Person as 'aPerson'

	fmt.Println(joey.Name)
}
```
Here the variable `aPerson` is created, after which we can use the Go `&` syntax to get this variable's reference (location in memory) and assign it to `myPointer`. Importantly, both `myPointer` and `aPerson` now point to the same variable in memory, and modifications made to either will apply to both.

```golang
func main() 
	var myPointer *person
	myPointer = &anotherPerson

	anotherPerson.Name = "Pete"

	fmt.Println(myPointer.Name) // This will print "Pete"!
}
```

### B) Handle the nil pointer{#solution-b}

Going back to the code used in [Step 2](#step-2), we can expand this to check for and 'handle' a nil value before the code continues.

``` golang
type NumberObject struct {
	number int
}

func createNumberObj(num int) (result *NumberObject) {
	// Returns a pointer to a NumberObject if the number is allowed, otherwise returns nil
	if num < 100 {
		numberObj := NumberObject{num}
		return &numberObj // Returns a reference to the new object
	} else {
		return nil
	}
}

func main() {
	myNumberObject := createNumberObject(101)

	if myNumberObject == nil {
		log.Fatal("Failed to create number object!")
	}

	fmt.Println(myNumberObject.number) // This line is not reached if num >= 100!
}
```

There are several ways this situation could be handled; in this particular instance the `log.Fatal` function will terminate the program if myNumberObject is a nil pointer. Another option would be to return an error in the `createNumberObj` function informing the user that the inputted number was too high. A further option, and one which would allow the program to continute executing, would be to create and reference a new variable, as seen in [Solution C](#solution-c).

### C) Create and reference a new variable{#solution-c}
``` golang
type NumberObject struct {
	number int
}

func createNumberObj(num int) (result *NumberObject) {
	numberObj := NumberObject{} // Creates a new, empty NumberObject
	if num < 100 {
		numberObj.number = num
	}
	return &numberObj // Returns a reference to the new object
}

func main() {
	myNumberObject := createNumberObject(101)

	fmt.Println(myNumberObject.number) // Will print 0 instead of causing a panic!
}
```

Here we have restructured the program to first create a new variable, and then edit the properties of this object as the program executes, removing the risk of the function returning a nil pointer. In the event it is not explicitly set, the value of `NumberObject.number` will default to 0, rather than nil as you might expect - this is because Go has default 'zero values' for all it's types, which you can read more about [here](https://yourbasic.org/golang/default-zero-value/).

## Further Information {#further-information}
[Gotcha Nil Pointer Dereference](https://yourbasic.org/golang/gotcha-nil-pointer-dereference/)

[Golang default zero values](https://yourbasic.org/golang/default-zero-value/)

[Go Pointers](https://tour.golang.org/moretypes/1)

## Owner {#owner}

[Joey](https://github.com/jabray5)

