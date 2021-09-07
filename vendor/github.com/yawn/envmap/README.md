# envmap

[![Build Status](https://travis-ci.org/yawn/envmap.svg)](https://travis-ci.org/yawn/envmap)

`envmap` provides access to environment variables as a `map[string]string` and
can convert those maps back to `[]string`. It can also `push` and `pop` prefixes
to (and from) environment variables to allow use cases such as a temporary (nested)
override of environment variables.
