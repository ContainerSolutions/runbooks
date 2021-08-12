---
title: "Cannot Find Module for Path"
summary: "Summary here"
draft: true
---

## Overview {#overview}

This issue happens when Go can't locate a module you're trying to use. This is common when trying to use a module on your local machine, particularly since Go version 1.11 introduced [Go Modules](#https://blog.golang.org/using-go-modules)

``` golang
// ./main.go
package main

import (
	"fmt"

	"./fruit"
)

func main() {
	fmt.Println(fruit.GetFruit())
}

```
``` golang
// ./fruit/fruitcart.go
package fruit

func GetFruit() string {
	return "Apple"
}
```
```
% go run main.go
build command-line-arguments: cannot find module for path
```

With Go Modules enabled we encounter a build error if we try to import our local module in this way

## Check RunBook Match {#check-runbook-match}

When you ... you expect to see ...

## Initial Steps Overview {#initial-steps-overview}

1) [Check your go.mod file](#step-1)

2) [Tell Go to use a local module](#step-2)

3) [Disable Go Modules](#step-3)

## Detailed Steps {#detailed-steps}

### 1) Step 1 {#step-1}
The go.mod file at the root of your project determines which modules are required by the project. If this file is not present and you try to access a package you may encounter a related error: `no required module provides package` as demonstrated below.
``` golang
// No go.mod file present
import (
	"fmt"

	"rsc.io/quote" // A package on the internet
)

func main() {
	fmt.Println(quote.Hello())
}
```
```
% go run main.go
main.go:6:2: no required module provides package rsc.io/quote: go.mod file not found in current directory or any parent directory; see 'go help modules'
```
In this event, the first step is to create a go.mod file for your current project, which will allow you to manage dependencies. This can be done with the command `go mod init example.com/your-module-name`.
* It's important to note that the url, in this case `example.com/your-module-name` *should* in theory be a location on the internet where the module you're currently working on will be accessible - a Github repo for example. However, this is not strictly necessary, and the subsequent steps will work regardless of how you set this URL for now - indeed you can leave it exactly as 'example.com' and issues wont arise until you come to publish your package.

### 2) Another step {#step-2}

### 3) Disable Go Modules {#step-3}
You can disable Go Modules in order to revert to the 'old' way of handling dependencies, though this may have unexpected consequences and its recommended to understand how Go 

[Link to Solution A](#solution-a)

## Solutions List {#solutions-list}

A) [Solution](#solution-a)

## Solutions Detail {#solutions-detail}

### Solution A {#solution-a}

## Check Resolution {#check-resolution}

## Further Steps {#further-steps}

1) [Further Step 1](#further-steps-1)

### Further Step 1 {#further-steps-1}

## Further Information {#further-information}

## Owner {#owner}

email

[//]: # (REFERENCED DOCS)
[//]: # (eg https://somestackoverflowpage)
[//]: # ()
