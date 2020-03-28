#!/bin/bash

echo Removing old builds . . . 
rm export/lin/*
rm export/win/*
rm export/mac/*
echo Old builds removed . . . 

echo Exporting Linux build . . . 
godot-3.2.1-headless --path godot --export "Linux/X11" ../export/lin/spindle-of-serendipity

echo Exporting Windows build
godot-3.2.1-headless --path godot --export "Windows Desktop" ../export/win/spindle-of-serendipity.exe

echo Exporting Mac build
godot-3.2.1-headless --path godot --export "Mac OSX" ../export/mac/spindle-of-serendipity-mac.zip

echo Pushing to Itch.io via butler . . .
butler push export/lin zacryol/spindle-of-serendipity:linux --userversion-file version.txt
butler push export/win zacryol/spindle-of-serendipity:windows --userversion-file version.txt
butler push export/mac zacryol/spindle-of-serendipity:mac --userversion-file version.txt
echo Done!
