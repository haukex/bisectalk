#!/bin/bash
set -euxo pipefail

# Make a copy of the bisect script - usually not necessary, but because in this
# special case, the bisect script is part of the same repository, we need to do
# this, otherwise checking out older versions will remove the bisect script!
TEMPF="`mktemp`"
trap 'rm -f "$TEMPF"' EXIT
cp "$1" "$TEMPF"
chmod 700 "$TEMPF"

cd "`git rev-parse --show-toplevel`"
git bisect start
git bisect old `git rev-list --max-parents=0 HEAD` # oldest
git bisect new HEAD
git bisect run "$TEMPF" # exit 0 => old, exit 1 => new

set +x
echo "Done. You may now run 'git bisect log' to see the log"
echo "and/or 'git bisect reset' to clean up after bisection."
