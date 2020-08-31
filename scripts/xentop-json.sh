#!/bin/bash

set -e

#
# Checking Requirements
if ! `command -v jq >/dev/null 2>&1`
then
	echo "Please install jq."
	echo
	exit 1
fi

#
# Generate JSON
# - Get stats from xentop
# - Ignore the header
# - Split the input lines and any number of whitespaces,
#   map the values and truncate the first iteration, as
#   as the first one does always show 0% CPU.
sudo xentop -f -d2 -b -i2 | awk '!/NAME/' | \
	jq --slurp --raw-input 'split("\n") |
		map([ split(" ")[] |
		select(. != "") ]) |
		map({
			name:		.[0],
			state:		.[1],
			cpu_sec:	.[2],
			cpu_used:	.[3],
			mem_kb:		.[4],
			mem_used:	.[5],
			maxmem_kb:	.[6],
			maxmem_used:.[7],
			vcpus:		.[8],
			nets:		.[9],
			nettx:		.[10],
			netrx:		.[11],
			vbds:		.[12],
			vbd_oo:		.[13],
			vbd_rd:		.[14],
			vbd_wr:		.[15],
			vbd_rsect:	.[16],
			vbd_wsect:	.[17],
			ssid:		.[18]
		}) | reverse | unique_by(.name)'
