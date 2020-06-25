---
title: "Module Not Found"
summary: "Python 'Module Not Found' Errors"
---

## Overview {#overview}

This issue happens when Python attempts to load a module and cannot find the module to load.

## Check RunBook Match {#check-runbook-match}

When you run a Python application, script, or interactive terminal, you see an error that looks like this:

```python
Traceback (most recent call last):
  File "afile.py", line 1, in <module>
    import doesnotexist
ImportError: No module named doesnotexist
```

## Initial Steps Overview {#initial-steps-overview}

[//]: # (double import?, name shadowing?, stale bytecode)

1) [Check module exists](#step-1)

2) [Check command line loading](#step-2)

3) [Check module is correctly set up](#step-3)

4) [Check installation method](#step-4)

5) [Module in a subfolder?](#step-5)

6) [Double import trap?](#step-6)

7) [Virtualenv activated?](#step-7)

## Detailed Steps {#detailed-steps}

### 1) Check module exists {#step-1}

First, determine that the module exists on your system, and where.

There are a number of ways to determine this if you are unsure how to proceed.

### 1.1) Use locatedb {#step-1-1}

If you have a system with locatedb installed on it and have access to update it, and are looking for a module called `modulename`, you can try running:

```shell
sudo updatedb
locate modulename | grep -w modulename$
```

which should output possible locations where the modules is installed.

If `locatedb` is not installed, or not up to date/under your control, then you can try and use `find` to search for the module in a similar way. Or you can look at using other tools available to you in your environment.

### 1.2) Use the sys.path {#step-1-2}

If you know the version of Python you are using on the command line is correct (see [step 2.1](#step-2-1)), then you can check the default path where Python modules are searched for by starting up Python on the command line and running:

```python
>>> import sys
>>> sys.path
```

The output will show you the folders that python searches through looking for Python packages in their immediate subfolders.

The `sys.path` value is figured out on startup by Python running a `site.py` located under the Python installation. This dynamically picks up relevant folders based on the code in that file.

### 2) Check command line {#step-2}

After you have determined that the module exists, check that the module loads when you run Python on the command line.

You can do this by running Python on the command line, and typing at the prompt:

```python
import modulename
```

if the prompt returns without a message, then the module was loaded OK.

If this doesn't solve your problem because the program you were running was not running on the command line, OR you still the same error, consider the following possibilities:

#### 2.1) You are using the wrong Python version {#step-2-1}

It may be that you are using Python version 2.x instead of 3.x, or vice versa. Or even a different minor or point version of Python. Different Python versions can look in different locations for their libraries, and so using the wrong version can mean that the library can't be found.

If your Python module was in a folder with a version number in it, eg:

```shell
/Library/Python/3.7/site-packages
```

then this may be the problem you are facing.

#### 2.2) Your PYTHONPATH is misconfigured {#step-2-2}

If your module is in a non-standard location, then it's possible your PYTHONPATH needs to be configured, or reconfigured.

For more information on this, see [here](https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPATH).

### 3) Check the module is correctly set up {#step-3}

If you are using a pre-3.3 version of Python, then it is a requirement that a Python module contains a file called `__init__.py`.

The inclusion of the file is often forgotten about when creating modules on-the-fly, so is a frequent cause of failure.

You may also want to consider whether the user you are running as has the right permissions to access the files and folders (see [step 4](#step-4)).

### 4) Check installation method {#step-4}

If you installed the module using `pip` or some similar package management method, then consider:

- Did you install as the root user (using `sudo` or similar)

- Did you install as a user other than the user running the Python import?

### 5) Check installation method {#step-5}

Is the module you are trying to load in a subfolder?

If so, you may need to more carefully qualify your module import. See [here](http://python-notes.curiousefficiency.org/en/latest/python_concepts/import_traps.html) for more background.

### 6) Double import trap? {#step-6}

If you have `PYTHONPATH` set in your environment, or are adding to your `sys.path` within your code or configuration, you may be falling victim to this trap, which can cause havoc with relative imports and the like. See [here](http://python-notes.curiousefficiency.org/en/latest/python_concepts/import_traps.html) for more background.

### 7) Virtualenv activated? {#step-6}

If your python code runs in a [virtualenv](https://docs.python.org/3/tutorial/venv.html), you may need to activate it for this error to be resolved. See [solution A](#solution-a) for more on this.

## Solutions List {#solutions-list}

A) [Activate your virtualenv](#solution-a)

## Solutions Detail {#solutions-detail}

### A) Activate your virtualenv {#solution-a}

Typically, this will require you to run:

```shell
virtualenv .
source bin/activate
```

before you re-run your code.

## Check Resolution {#check-resolution}

The application or steps followed at the start no longer result in an error.

## Further Information {#further-information}

This is an excellent resource in this context, for background and troubleshooting: [Import traps](http://python-notes.curiousefficiency.org/en/latest/python_concepts/import_traps.html)

General primer on Python packages:

- [Python packages, v2](https://docs.python.org/2/tutorial/modules.html#packages)

- [Python packages, v3](https://docs.python.org/3/tutorial/modules.html#packages)

[Virtualenvs](https://docs.python.org/3/tutorial/venv.html)

## Owner {#owner}

[Ian Miell](https://github.com/ianmiell)

[//]: # (REFERENCED DOCS)
[//]: # (https://askubuntu.com/questions/1017721/python-module-not-found-immediately-after-installing-it DONE)
[//]: # (https://docs.python.org/3/reference/import.html DONE)
[//]: # (http://python-notes.curiousefficiency.org/en/latest/python_concepts/import_traps.html TODO)
[//]: # (https://stackoverflow.com/questions/37233140/python-module-not-found DONE)
[//]: # ()
