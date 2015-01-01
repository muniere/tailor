# tailor

## Overview

Execute `tail -f` in multiple servers and output with labels.

## Requirements

- [Ruby](https://www.ruby-lang.org/) >= 2.1.0
- [Rake](http://docs.seattlerb.org/rake/) >= 10.0.0
- [Bundler](http://bundler.io/) >= 1.7.0

## Get started

```bash
# clone
$ git clone git@github.com:muniere/tailor.git

# install
$ rake install

# define a new project
$ tailor new my-project

# start to tail logs with project
$ tailor start my-project

# edit a project
$ tailor edit my-project

# delete a project
$ tailor delete my-project

# list defined projects
$ tailor list
```
