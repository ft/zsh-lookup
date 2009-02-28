#!/bin/sh

# fixes [PATCH] to PATCH:
#   and [PATCH m/n] to PATCH: (m/n)
#
# zsh-workers prefers PATCH: as its prefix.
# gitfp() in my zsh configuration handles this automatically.

[ -z "$1" ] && exit 1

(
    printf '/^Subject: \[\n'
    printf 's,\[PATCH \([0-9]\+/[0-9]\+\)\],PATCH: (\\1),\n'
    printf 'w\nq\n'
) | ed "$1" > /dev/null 2>&1

[ "$?" -eq 0 ] && exit 0

(
    printf '/^Subject: \[\n'
    printf 's,\[PATCH\],PATCH:,\n'
    printf 'w\nq\n'
) | ed "$1" > /dev/null 2>&1

exit 0
