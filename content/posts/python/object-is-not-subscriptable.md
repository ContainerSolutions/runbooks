---
title: "Object Is Not Subscriptable"
summary: "Fixing this cryptic Python TypeError"
---

## Overview {#overview}

You get an error complaining:
`TypeError: object is not subscriptable`

Specific examples:
* `TypeError: 'type' object is not subscriptable`
* `TypeError: 'function' object is not subscriptable`

e.g.

```python
Traceback (most recent call last):
  File "afile.py", line , in aMethod
    map[value]
TypeError: 'type' object is not subscriptable
```

## Problem {#problem}

This problem is caused when you treat an object that cannot be indexed by trying to access it by an index or "subscript". In the above example, I'm looking for `map[value]` but `map` is already a built-in type that doesn't support accessing indexes. You would get a similar error if you tried to call `print[42]` because `print` is a built-in function.

## Initial Steps Overview {#initial-steps-overview}

1) [Check for built-in words in the given line](#step-1)

2) [Check for reserved words in the given line](#step-2)

3) [Check you are not trying to index a function](#step-3)

## Detailed Steps {#detailed-steps}

### 1) Check for built-in words in the given line {#step-1}

In the above error, we see Python shows the line
```python
map[value]
```

This is saying that the part just before `[value]` can not be subscripted (or indexed). In this particular instance, the problem is that the word `map` is already a builtin identifier used by Python and it has not been redefined by us to contain a type that subscripts.

You can see a full list of built-in identifiers via the following code:

```python
# Python 3.0
import builtins
dir(builtins)

# For Python 2.0
import __builtin__ 
dir(__builtin__)
```

### 2) Check for instances of the following reserved words {#step-2}

It may also be that you are trying to subscript a keyword that is reserved by Python `True`, `False` or `None`

```python
>>> True[0]
<stdin>:1: SyntaxWarning: 'bool' object is not subscriptable; perhaps you missed a comma?
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: 'bool' object is not subscriptable
```

### 3) Check you are not trying to access elements of a function {#step-3}

Check you are not trying to access an index on a method instead of the results of calling a method.

```python
txt = 'Hello World!'

# Incorrectly getting the first word
>>> txt.split[0]

Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: 'builtin_function_or_method' object is not subscriptable

# The correct way
>>> txt.split()[0]

'Hello'
```

You will get a similar error for functions/methods you have defined yourself:

```python
def foo():
    return ['Hello', 'World']

# Incorrectly getting the first word
>>> foo[0]

Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: 'function' object is not subscriptable

# The correct way
>>> foo()[0]
'Hello'
```

## Solutions List {#solutions-list}

A) [Initialize the value](#solution-a)

B) [Don't shadow built-in names](#solution-b)

## Solutions Detail {#solutions-detail}

### A) Initialize the value {#solution-a}

Make sure that you are initializing the array before you try to access its index.

```python
map = ['Hello']
print(map[0])

Hello
```

### B) Don't shadow built-in names {#solution-b}

It is generally not a great idea to shadow a language's built-in names as shown in the above solution as this can confuse others reading your code who expect `map` to be the builtin `map` and not your version.

If we hadn't used an already taken name we would have also got a much more clear error from Python, such as:
```python
>>> foo[0]
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
NameError: name 'foo' is not defined
```

But don't just take our word for it: [see here](https://stackoverflow.com/q/9109333)

## Further Information {#further-information}

* [Python 2: Subscriptions](https://docs.python.org/2.0/ref/subscriptions.html)
* [Python 3: Subscript notation](https://docs.python.org/3.0/reference/datamodel.html#index-694)

## Authors {#authors}

[@Gerry](https://github.com/gerrywastaken) 

[//]: # (REFERENCED DOCS)
[//]: # (https://docs.python.org/2.0/ref/subscriptions.html DONE)
[//]: # (https://docs.python.org/3.0/reference/datamodel.html#index-694 DONE)
