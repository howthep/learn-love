cmd='love'
if ! type $cmd &>/dev/null ;then
	echo $cmd not found!
	return 1
fi
$cmd .
