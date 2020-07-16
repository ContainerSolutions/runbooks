---
title: "Ordinal Not in Range"
summary: "Python encoding/decoding errors"
draft: true
---

## Overview {#overview}

This issue happens when Python can't correctly work with a string variable.

Strings can contain any sequence of bytes, but when Python is asked to work with the string, it may decide that the string contains invalid bytes.

In these situations, an error is often thrown.

## Check RunBook Match {#check-runbook-match}

If you see an error that looks like this:

```
Traceback (most recent call last):
  File "unicode_ex.py", line 3, in
    print str(a) # this throws an exception
UnicodeEncodeError: 'ascii' codec can't encode character u'\xa1' in position 0: ordinal not in range(128)
```

ie one that mentions `ordinal not in range` and/or `codec can't encode character` or `codec can't decode character` then this runbooks is a match.

## Initial Steps Overview {#initial-steps-overview}

1) [Check Python version](#step-1)

2) [Check ](#step-2)

## Detailed Steps {#detailed-steps}

### 1) Check Python version {#step-1}

The Python version you are using is significant.

### 2) TODO {#step-2}

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
[//]: # (http://effbot.org/pyfaq/what-does-unicodeerror-ascii-decoding-encoding-error-ordinal-not-in-range-128-mean.htm - TODO)
[//]: # (https://markhneedham.com/blog/2015/05/21/python-unicodeencodeerror-ascii-codec-cant-encode-character-uxfc-in-position-11-ordinal-not-in-range128/ - TODO)
[//]: # (https://pythonhosted.org/kitchen/unicode-frustrations.html - TODO)
[//]: # (https://stackoverflow.com/questions/9942594/unicodeencodeerror-ascii-codec-cant-encode-character-u-xa0-in-position-20 - TODO)
[//]: # (https://www.b-list.org/weblog/2007/nov/10/unicode/ - TODO)
[//]: # (https://www.joelonsoftware.com/2003/10/08/the-absolute-minimum-every-software-developer-absolutely-positively-must-know-about-unicode-and-character-sets-no-excuses/ - TODO)
[//]: # (https://www.saltycrane.com/blog/2008/11/python-unicodeencodeerror-ascii-codec-cant-encode-character/ - TODO)

