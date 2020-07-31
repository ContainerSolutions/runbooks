---
title: "Ordinal Not in Range"
summary: "Python encoding/decoding errors"
---

## Overview {#overview}

Example errors:

```
Traceback (most recent call last):
  File "unicode_ex.py", line 3, in
    print str(a) # this throws an exception
UnicodeEncodeError: 'ascii' codec can't encode character u'\xa1' in position 0: ordinal not in range(128)
```

This issue happens when Python can't correctly work with a string variable.

Strings can contain any sequence of bytes, but when Python is asked to work with the string, it may decide that the string contains invalid bytes.

In these situations, an error is often thrown that mentions `ordinal not in range`, or `codec can't encode character`, or `codec can't decode character`.

Here's a bit of code that may reproduce the error in Python 2:

```
a='\xa1'
print(a + ' <= problem')
unicode(a)
```

## Initial Steps Overview {#initial-steps-overview}

1) [Check Python version](#step-1)

2) [Determine codec and character](#step-2)

## Detailed Steps {#detailed-steps}

### 1) Check Python version {#step-1}

The Python version you are using is significant.

You can determine the Python version by running:

```
python --version
```

or, if you have access to the running code, by logging it:

```
print(sys.version)
```

The major number (2 or 3) is the number you are interested in.

It is expected that you are using Python2.

### 2) Determine interpreting codec and character {#step-2}

Get this from the error message:

```
UnicodeEncodeError: 'ascii' codec can't encode character u'\xa1' in position 0: ordinal not in range(128)
```

In this case, the code is `ascii` and the character is the hex character `A1`.

What is happening here is that Python is trying to interpret a string, and expects that the bytes in that string are legal for the format it's expecting. In this case, it's expecting a string composed of [ASCII](https://en.wikipedia.org/wiki/ASCII) bytes. These bytes are in the range 0-127 (ie 8 bytes). The hex byte `A1` is 161 in decimal, and is therefore out of range.

When Python comes to interpret this string in a context that requires a codec (for example, when calling the `unicode` function), it tries to 'encode' it with the codec, and can hit this problem.

### 3) Determine desired codec {#step-2}

You need to figure out how the bytes should be interpreted.

Most often in everyday use (eg web scraping or document ingestion), this is `utf-8`.

Once you have determined the desired codec, [solution A](#solution-a) may help you.

## Solutions List {#solutions-list}

A) [Decode the string](#solution-a)


## Solutions Detail {#solutions-detail}

### A) Decode the string {#solution-a}

If you have a string `s` that you want to interpret as utf-8 data, you can try:

```
s = s.decode('utf-8')
```

to re-encode the string with the appropriate codec.

## Further Information {#further-information}

## Owner {#owner}

[Ian Miell](https://github.com/ianmiell)


[//]: # (REFERENCED DOCS)
[//]: # (http://effbot.org/pyfaq/what-does-unicodeerror-ascii-decoding-encoding-error-ordinal-not-in-range-128-mean.htm - TODO)
[//]: # (https://markhneedham.com/blog/2015/05/21/python-unicodeencodeerror-ascii-codec-cant-encode-character-uxfc-in-position-11-ordinal-not-in-range128/ - TODO)
[//]: # (https://pythonhosted.org/kitchen/unicode-frustrations.html - TODO)
[//]: # (https://stackoverflow.com/questions/9942594/unicodeencodeerror-ascii-codec-cant-encode-character-u-xa0-in-position-20 - TODO)
[//]: # (https://www.b-list.org/weblog/2007/nov/10/unicode/ - TODO)
[//]: # (https://www.joelonsoftware.com/2003/10/08/the-absolute-minimum-every-software-developer-absolutely-positively-must-know-about-unicode-and-character-sets-no-excuses/ - TODO)
[//]: # (https://www.saltycrane.com/blog/2008/11/python-unicodeencodeerror-ascii-codec-cant-encode-character/ - TODO)

