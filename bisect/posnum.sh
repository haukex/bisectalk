#!/bin/bash
set -euo pipefail

# exit 0 => old, exit 1 => new
test "`./math.pl '-5 + +10'`" == "5"
