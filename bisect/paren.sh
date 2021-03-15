#!/bin/bash
set -euo pipefail

# exit 0 => old, exit 1 => new
test "`./math.pl '(1+2)*3'`" != "9"
