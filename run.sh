#! /bin/bash
# perl -ep 's/^require*lldebug)/#\1/' main.lua
if [ "$1" == 'debug' ]; then
	echo 'debug'
	perl -i.bak -pe 's/^--\s*// if /^--.*require.*debug/' main.lua
else
	echo 'run'
	perl -i.bak -pe 's/(.*)/-- \1/ if /^require.*debug/' main.lua
fi
cmd='love'
if ! type $cmd &>/dev/null ;then
	echo $cmd not found!
	return 1
fi
$cmd .
