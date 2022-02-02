# Overview

A wrapper around flake8's cli that uses cache at file level

# Setup

## Requirements

* Python 3.10+

## Installation

Install it directly into an activated virtual environment:

```text
$ pip install forked-flake8-cached
```

or add it to your [Poetry](https://poetry.eustace.io/) project:

```text
$ poetry add forked-flake8-cached
```

# Usage

After installation, the package can imported:

```shell
# it accepts all arguments as flake8
$ flake8-cached .
```

# Note

It creates cache files under `.cache/flake8` under the project directory. 
It is not cleaned up even if there is some config or python binary changes. 
Please remove the folder and re-run if you get stale results.
It is a simple cache implementation intended to be used during development.
