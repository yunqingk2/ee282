#!/usr/bin/env bash
set -eo pipefail

# baseCount includes Ns; nBaseCount counts Ns; seqCount counts sequences.
faSize -tab "$1"
