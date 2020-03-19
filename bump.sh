#! /bin/bash

VERSION_FILE=version.txt
if [ $# -eq 0 ]
then
	VERSION=$(cat $VERSION_FILE)
else
	VERSION=$1
	echo $VERSION > $VERSION_FILE
fi

echo $VERSION
