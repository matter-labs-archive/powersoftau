#!/bin/bash
#
# runs all tests
for i in /app/test/*.sh ; do
	printf "=====================\nExecute Test $i\n====================="
	. "$i"
done
