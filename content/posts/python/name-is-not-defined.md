---
title: "Name is not defined when calling module"
summary: "When calling a method on a module's class you get a NameError telling you the class doesn't exist"
---

## Overview {#overview}


This issue happens when you try to invoke a class within a module without specifying the module anywhere

## Check RunBook Match {#check-runbook-match}

If you see an error like this:

```
Traceback (most recent call last):
  File "main.py", line 2, in <module>
    Foo.hello()
NameError: name 'Foo' is not defined
```

then this runbook is a match.

When you call a class method within a from a module you expect to see the result of that call and for that class to be defined.

## Initial Steps Overview {#initial-steps-overview}

1) [Change the import to load the class directly](#step-1)

2) [Change the import to load the class directly](#step-2)

## Detailed Steps {#detailed-steps}

### 1) Change the call to reference the module {#step-1}

```python
# foo.py
class Foo():
  @staticmethod
  def bar():
    print("Hello")

# main.py
import foo
Foo.bar() # NameError: name 'Foo' is not defined
```

Above we see that `Foo.bar()` doesn't work, which is because we only have access to the module `foo` and not the class within it. To access this class we could instead do `foo.Foo.bar()`. In this case, `foo` is the module name and `Foo` is the class name.

You would have a similar problem if the casing of the class was the same as the module you would just receive [a different error]({{< relref "module-has-no-attribute.md" >}}).

### 2) Change the import to load the class directly {#step-1}

Given the example shown in [step #1](#step-1), the import within `main` can be changed to make the call work. We simply need to use the following format `from <modulename> import <classname>`. So in our example, this would be:

```python
from foo import Foo
Foo.bar() # This now works
```

## Check Resolution {#check-resolution}

Your call now works as expected.

## Further Information {#further-information}

* [NameError: Module 'foo' has no attribute 'bar']({{< relref "module-has-no-attribute.md" >}})
* [Python: Import vs From](https://stackoverflow.com/questions/9439480/from-import-vs-import)

## Authors {#authors}

[@gerry](https://github.com/gerrywastaken)

[//]: # (REFERENCED DOCS)
