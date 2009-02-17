#!/bin/sh

files="LOOKUP_browser LOOKUP_encode _lookup lookup"
subdir="Lookup"

if [ -z "$1" ] ; then
    printf 'usage: %s <dir>\n' $0
    printf '<dir> should be a directory in your $fpath.\n'
    exit 1
fi

if [ ! -e "$1" ] || [ ! -r "$1" ] || [ ! -w "$1" ] || [ ! -x "$1" ] ; then
    printf 'Given directory must be rwx!\n'
    exit 1
fi

fail=0
for file in .git ${files} ${subdir} ; do
    [ ! -e "${file}" ] && fail=1 && break
done

if [ "${fail}" -gt 0 ] ; then
    printf 'Only execute this script in the source repository!\n'
    exit 1
fi

doit() {
    echo "$@"
    "$@"
}

dir="$1"

for file in ${files} ; do
    [ -e "${dir}/${file}" ] && doit rm -f "${dir}/${file}"
done
doit rm -Rf "${dir}/${subdir}"

doit cp ${files} ${dir}
doit cp -R ${subdir} ${dir}
