package envmap

import (
	"fmt"
	r "regexp"
)

// Filter describes a function for filtering on Envmap keys
type Filter func(string) bool

// PrefixedKeysAll is an expression that matches optionally
// prefixed environment keys
func PrefixedKeysAll(prefix string) *r.Regexp {
	return PrefixedKeys(prefix, ".+")
}

// PrefixedKeys is an expression that matches optionally prefixed
// environment keys which are described through the keys sub-
// expression
func PrefixedKeys(prefix, keys string) *r.Regexp {
	return r.MustCompile(fmt.Sprintf(`^(%s+)?(%s)$`, r.QuoteMeta(prefix), keys))

}
