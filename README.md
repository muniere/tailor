# tailor

## Overview

Execute `tail -f` in multiple servers and output with labels.

## Requirements

- [Ruby](https://www.ruby-lang.org/) >= 2.1.0
- [Rake](http://docs.seattlerb.org/rake/) >= 10.0.0

## Get started

```bash
# clone
$ git clone git@github.com:muniere/tailor.git

# install
$ rake install

# uninstall
$ rake uninstall

# status
$ rake status

# configure
$ vim ~/.tailor/default.json

# execute
$ tailor
```

## Usage

```bash
# with default config
$ tailor

# with specific config for env
$ vim ~/.tailor/prd.json
$ tailor prd

# with specific cofig file
$ vim ~/dev.json
$ tailor ~/dev.json

# list available envs
$ tailor -l
```
