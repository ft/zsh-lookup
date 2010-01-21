#!/bin/sh

cd /usr/src/sys/zsh.git
git checkout master
git clean -x -d -f
git branch -D zsh-lookup

git checkout -b zsh-lookup
mkdir Functions/Lookup
cp ~/src/code/zsh-lookup/Lookup/lookupinit Functions/Lookup
cp ~/src/code/zsh-lookup/Lookup/LOOKUP_*   Functions/Lookup

printf '/^functions=\ns,'\''$, Functions/Lookup/* Functions/Lookup/Backend/*'\'',\nw\nq\n' | ed Src/zsh.mdd

git add .
git commit -m'Add basics of the lookup() subsystem

To give it a try:
  % autoload -Uz lookupinit && lookupinit
  % lookup -h

This commit does not include any backends yet.'

cp ~/src/code/zsh-lookup/_lookup Completion/Zsh/Command

git add .

git commit -m'Add completion widget for lookup() subsystem

This is just completion for the main lookup() options.
_call_function calls the backend-function for backend specific
completions.'

mkdir Functions/Lookup/Backend

for backend in ~/src/code/zsh-lookup/Lookup/Backends/LOOKUP_be_* ; do
    name="${backend##*/LOOKUP_be_}"
    case "${name}" in (*~) continue;; esac
    cp "${backend}" Functions/Lookup/Backend
    git add .
    git commit -m'lookup: Add '"${name}"' backend'
done

printf '/^menu(Prompt Themes)\na\nmenu(World Wide Web Services)\n.\n/^texinode(Prompt Themes\ns,ZLE Functions,World Wide Web Services,\n/^sect(ZLE Functions)\n-\n-\n.r /home/hawk/src/code/zsh-lookup/contrib.yo\nw\nq\n' | ed Doc/Zsh/contrib.yo
printf '/^texinode(ZLE Functions\ns,Prompt Themes,World Wide Web Services,\nw\nq\n' | ed Doc/Zsh/contrib.yo
git add .
git commit -m'lookup: Add documentation to Doc/Zsh/contrib.yo'
