#!/bin/bash
#
# runs all tests
for i in /app/test/*.sh ; do
	. "$i"
done
