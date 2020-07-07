---
title: "Module has no attribute"
summary: "Recieving an AttributeError telling you that your module doesn't have the method that you are calling"
---

## Overview {#overview}

```
python main.py 
Traceback (most recent call last):
  File "main.py", line 2, in <module>
    foo.bar()
AttributeError: module 'foo' has no attribute 'bar'
```

This issue happens when you try to invoke a class within a module without specifying the module anywhere

## Check RunBook Match {#check-runbook-match}

When you call a class method within a from a module you expect that class and its methods to be available.

## Initial Steps Overview {#initial-steps-overview}

1) [Call class directly](#step-1)

2) [Change the import to load the class directly](#step-2)


## Detailed Steps {#detailed-steps}

### 1) Call the class direction {#step-1}

```python
# foo.py
class foo():
  @staticmethod
  def bar():
    print("Hello")

# main.py
import foo
```

Given the above code a call to `foo.bar()` within `main.py` would result in an error about the module 'foo' not having the attribute 'bar'. This is because we have only made the module accessible and not it's class `foo`. So to call it we could instead do `foo.foo.bar()` with the first foo  being the module name and the second being the class name.

### 2) Change the import to load the class directly {#step-2}

If we change the import from [step 1](#step-1) to instead be `from <modulename> import <classname>` this will make the class `foo` directly accessible.

e.g.

```python
# main.py
from foo import foo
foo.bar() # This now works!
```

## Check Resolution {#check-resolution}

Your call to the method should now work as expected.

## Further Information {#further-information}

* [NameError: Name 'Foo' is not defined, when calling module class]({{< relref "name-is-not-defined.md" >}})
* [Python: Import vs From](https://stackoverflow.com/questions/9439480/from-import-vs-import)

## Authors {#authors}

[@gerry](https://github.com/gerrywastaken)

[//]: # (REFERENCED DOCS)
[//]: # (https://stackoverflow.com/questions/47323411/attributeerror-module-object-has-no-attribute-xxxx)
