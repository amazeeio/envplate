package doubledash

import "os"

var (
	// Args are the parameters relevant to this program
	Args []string

	// Xtra are the parameters relevant to another program
	Xtra []string
)

func init() {
	Args, Xtra = Split(os.Args)
}

// Split splits up the passed args into the real args
// (before a potential double dash) and the extra args
// (after a potential doubledash)
func Split(args []string) (real []string, xtra []string) {

	const doubleDash = "--"

	split := len(args)

	for idx, e := range args {

		if e == doubleDash {
			split = idx
			break
		}

	}

	real = args[0:split]

	if split < len(args) {
		xtra = args[split+1 : len(args)]
	} else {
		xtra = []string{}
	}

	return

}
