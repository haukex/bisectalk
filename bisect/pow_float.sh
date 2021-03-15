#!/bin/bash
set -euo pipefail

# exit 0 => old, exit 1 => new
test "`./math.pl '9^0.5'`" != "3"
