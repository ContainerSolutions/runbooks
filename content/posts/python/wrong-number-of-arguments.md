---
title: "Wrong Number of Arguments"
summary: "'F() takes X positional arguments but Y were given' errors"
---

## Overview {#overview}

Example error:

```
Traceback (most recent call last):
  File "afile.py", line 15, in <module>
    print(aFunction(width, height))
TypeError: aFunction() takes 2 positional arguments but 3 were given
```

Python can report that you are passing one more argument than it appears you are sending.

For example, you are passing two arguments, but Python claims you have passed three.

## Initial Steps Overview {#initial-steps-overview}

1) [Method in Python class?](#step-1)

2) [Method outside Python class?](#step-2)

## Detailed Steps {#detailed-steps}

### 1) Method inside Python class? {#step-1}

This issue occurs because your method is declared in the context of a Python class.

For example, if your method is `bar` it is indented inside a `class` block, like so:

```python
class Foo():
    def bar(self, a, b):
        print("bar:", self, a, b)
```

If your method is outside a Python `class`, then go to [step 2](#step-2).

If your method is inside a Python `class`, then there are a number of options to consider.

#### 1.1) Instance method {#step-1-1}

If your method is a straighforward instance method (ie has no decorators such as `@staticmethod` or `@classmethod` above the declaration), then it is likely that you forgot to add a first argument to the method signature.

See [solution A](#solution-a) if this is the case.

#### 1.2) Class method {#step-1-2}
If your method is a class method (ie has the `@classmethod` decorator above the declaration), then it is likely that you forgot to add a first argument to the method signature.

See [solution B](#solution-b) if this is the case.

#### 1.3) Static method {#step-1-2}

It is also possible that your method should be a static method.

If your method is a utility function that:

- doesn't need an instance of the class to be created to be used, or

- doesn't need to know about the class

then you may want to consider using a static method.

This resolves the problem through the method not receiving an unnecessary first argument (which both [1.1](#step-1-1) and [1.2](#step-1-2) above, do.

### 2) Method outside Python class? {#step-2}

If your method is outside a Python class, then it is likely that you have simply passed the wrong number of variables. Here's some tips that may help:

- Check that the function you believe you are calling is actually the function that is being called

- Look more closely at the function signature to determine what the correct number of arguments is and whether you are passing that number


## Initial Steps Overview {#initial-steps-overview}

## Solutions List {#solutions-list}

A) [Add `self` to method](#solution-a)

B) [Add `cls` argument to class method](#solution-b)

C) [Change method to `@staticmethod`](#solution-c)


### A) Add `self` to method {#solution-a}
Instance methods receive the instance as their first argument, so you must add this to the list of parameters for your method. By convention, this variable is normally named `self`. For example, change:


```python
[...]
class Foo():
    def bar(a, b):
        print("bar:", self, a, b)
```

to:

```python
[...]
class Foo():
    def bar(self, a, b):
        print("bar:", self, a, b)
```


### B) Add `cls` argument to method {#solution-b}
Class methods receive a class, so you must add this to the list of parameters for your method. This is so that you can change values within the class or generate a new instance of the given class (factory method). By convention this variable is normally named `cls`. For example, change:

```python
class Foo():
[...]
    @classmethod
    def tee(a, b):
        print("tee:", cls, a, b)
```

to:

```python
class Foo():
[...]
    @classmethod
    def tee(cls, a, b):
        print("tee:", cls, a, b)
```


### C) Change method to `@staticmethod` {#solution-c}

This is achieved by adding a decorator to the method, eg changing:

```python
class Foo():
[...]
    def qux(a, b):
        print("qux:", a, b)
```

to

```python
class Foo():
[...]
    @staticmethod
    def qux(a, b):
        print("qux:", a, b)
```

## Check Resolution {#check-resolution}

You should no longer receive the error about being given more positional arguments than your method takes.

## Further Information {#further-information}

* [Class methods vs static methods](https://www.geeksforgeeks.org/class-method-vs-static-method-python/)
* [Static methods](https://docs.python.org/3/library/functions.html#staticmethod)
* [Class methods](https://docs.python.org/3/library/functions.html#classmethod)

## Authors {#authors}

[@Gerry](https://github.com/gerrywastaken)

[//]: # (REFERENCED DOCS)
[//]: # (https://www.geeksforgeeks.org/class-method-vs-static-method-python/)
[//]: # (https://realpython.com/primer-on-python-decorators/)
[//]: # ()
