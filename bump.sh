#! /bin/bash

VERSION_FILE=version.txt
CONFIG_FILE=godot/export_presets.cfg

if [ $# -eq 0 ]
then
	VERSION=$(cat $VERSION_FILE)
else
	VERSION=$1
	echo $VERSION > $VERSION_FILE
fi

echo $VERSION
sed -i "s/\(application\/version *= *\).*/\1\"$VERSION\"/" $CONFIG_FILE
sed -i "s/\(application\/short_version *= *\).*/\1\"$VERSION\"/" $CONFIG_FILE
sed -i "s/\(application\/file_version *= *\).*/\1\"$VERSION\"/" $CONFIG_FILE
sed -i "s/\(application\/product_version *= *\).*/\1\"$VERSION\"/" $CONFIG_FILE
