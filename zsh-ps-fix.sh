#!/bin/sh

for i in *.patch; do
    (
        printf '/^Subject:\n'
        printf 's,\[PATCH \([0-9]\+/[0-9]\+\)\],PATCH: (\\1),\n'
        printf 'w\nq\n'
    ) | ed "$i"
done
