---
title: "Cannot Find Module for Path"
summary: "Summary here"
draft: true
---

## Overview {#overview}

This issue happens when Go can't locate a module you're trying to use. This is common when trying to use relative imports to include a module which is present on your local machine, which was allowed until Go version 1.11 introduced [Go Modules](#https://blog.golang.org/using-go-modules).

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
Example error:
```
% go run main.go
build command-line-arguments: cannot find module for path
```

With Go Modules enabled we encounter a build error if we try to import our local module in this way

## Initial Steps Overview {#initial-steps-overview}

1) [Determine your Go version](#step-1)

2) [Check your go.mod file is present](#step-2)


## Detailed Steps {#detailed-steps}

### 1) Determine your Go version
```
% go version
go version go1.16.6 darwin/amd64
```
Use `go version` to determine your installation version. If this is 1.11 or higher, you are likely using Go Modules by default. This can be disabled to work as per previous versions of Go by following [Solution B](#solution-b) though, unless there is a specific cause to use this older system, it may be better to understand and adapt to the newer system by following [Step 2](#step-2).


### 2) Check your go.mod file is present {#step-2}
Under the new Go Modules system, every module is required to have a `go.mod` file present in its root directory. This file does two things: it identifies this folder as a module, and also specifies the module's dependencies. If this file is not present on your working module and you try to access a package elsewhere, you may encounter a related error: `no required module provides package`, as demonstrated below.
``` golang
// With no go.mod file present
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

You can simply look in the directory of your module to determine if you have a go.mod file included with your module. If this file is missing, you can create it by following [Solution A](#solution-a).

## Solutions List {#solutions-list}

A) [Create a Go.mod file](#solution-a)

B) [Disable Go Modules](#solution-b)

## Solutions Detail {#solutions-detail}

### A) Create a Go.mod file
In this event, the first step is to create a go.mod file for your current project. This can be done with the command `go mod init example.com/your-module-name`.

It's important to note that the url, in this case `example.com/your-module-name` *should* in theory be a location on the internet where the module you're currently working on will be accessible - a Github repo for example. However, this is not strictly necessary, and the subsequent steps will work regardless of how you set this project name for now - indeed you can leave it exactly as 'example.com' and issues wont arise until you come to publish your package and include it in future projects.

If your module is not published to the internet yet (for example if you are working on a new Git branch), you can follow [Further Step 1](#further-step-1) to tell Go to use a local module.

### B) Disable Go Modules {#solution-b}
You can disable Go Modules in order to revert to the 'old' way of handling dependencies, which allows for relative imports. This may have unexpected consequences if you've been using modules already, and it's recommended to understand how Go handles dependencies in this 'old' way using [GOPATH](https://golang.org/doc/gopath_code).

This is done by setting the environment variable `GO111MODULE=off`.

```
$ GO111MODULE=off go run main.go
Apple
```

Your code will then build while allowing modules to be imported locally.

## Further Steps {#further-steps}

1) [Tell Go to use a local module](#further-steps-1)

### 1) Tell Go to use a local module {#further-steps-1}
Within your go.mod file for your working project you can now require a module using its URL to use within this project. The module to be imported also requires its own go.mod file, so if this is a local module you'll need to create this in the same way. 

If the module you want to import is not published to the internet, you can use the 'replace' syntax to tell Go where to find it on your local machine instead instead.

Your go.mod file would then look something like this:
``` 
module example.com/your-module-name

go 1.16

require (
    example.com/fruit v1.2.3
)

replace example.com/fruit => ./fruit
```

## Further Information {#further-information}
[Go modules reference](https://golang.org/ref/mod)

[Stack Overflow](https://stackoverflow.com/questions/52123627/how-do-i-resolve-cannot-find-module-for-path-x-importing-a-local-go-module)

## Owner {#owner}

[Joey](https://github.com/jabray5)
