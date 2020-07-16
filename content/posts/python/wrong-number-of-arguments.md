---
title: "Wrong Number of Arguments"
summary: "Summary here"
---

## Overview {#overview}

```
Traceback (most recent call last):
  File "afile.py", line 15, in <module>
    print(aFunction(width, height))
TypeError: aFunction() takes 2 positional arguments but 3 were given
```

But you're only passing two arguments. Python is implicitly passing the object instance.

## Check RunBook Match {#check-runbook-match}

When Python says that you are passing one more argument than you are actually sending. eg. You are passing two arguments but Python claims you have passed 3.

This may be because you have set a method to be @classmethod when you meant to use @staticmethod and so the class is automatically passed as the first argument.

A similar situation is true for instance methods where the instance is automatically passed as the first argument.

Here's a quick look at situations where arguments are implicitly being passed. Note that in all three we only pass two variables, but in the case of the instance and class methods, Python adds an argument of it's own which needs to be there in the method's definition.

```python
class Foo():
    def bar(self, a, b):
        print("bar:", self, a, b)

    @classmethod
    def tee(cls, a, b):
        print("tee:", cls, a, b)

    @staticmethod
    def qux(a, b):
        print("qux:", a, b)

Foo().bar(1, 2)
Foo.tee(1, 2)
Foo.qux(1, 2)

# Output

# bar: <__main__.Foo object at 0x7fdc13acefa0> 1 2
# tee: <class '__main__.Foo'> 1 2
# qux: 1 2
```

## Initial Steps Overview {#initial-steps-overview}

1) [Accept self for instance methods](#step-1)
2) [Aceept class for Class methods](#step-2)
3) [Switch to a Static method](#step-2)

## Detailed Steps {#detailed-steps}

### 1) Accept self for instance methods {#step-1}
Instance methods receive the instance as their first argument, so you must add this to the list of parameters for your method. By convention, this variable is normally named `self`.

### 2) Aceept class for Class methods {#step-2}
Class methods receive a class, so you must add this to the list of parameters for your method. This is so that you can change values within the class or generate a new instance of the given class (factory method). By convention this variable is normally named `cls`.

### 3) Switch to a Static method {#step-2}
If you method is just a utility function that doesn't need an instance or to know about the class, then you should probably be using a Static method. This way you will not receive an unnecessary first argument.

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
