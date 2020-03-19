#! /bin/bash


if [ $# -eq 0 ]
then
	VERSION=$(cat version.txt )
else
	VERSION=$1
	echo $VERSION > version.txt
fi

echo $VERSION
