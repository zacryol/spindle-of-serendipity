#! /bin/bash


if [ $# -eq 0 ]
then
	VERSION=$(cat version.txt )
else
	VERSION=$1
fi

echo $VERSION
