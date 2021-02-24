# doubledash

[![Build Status](https://travis-ci.org/yawn/doubledash.svg)](https://travis-ci.org/yawn/doubledash)

Package `doubledash` splits args passed to a process into `Args` and `Xtra` with the latter being denoted by the presence of a single `--` argument. Everything following that argument becomes part of `Xtra`.

## Example

When calling `foo` with the arguments `bar wee -- gee dee -- bee` the value for `Args` and `Xtra` are going to be:

* `Args`: `bar` and `wee`
* `Xtra`: `gee`, `dee`, `--` and `bee`
