#!/bin/bash

echo Removing old builds . . . 
rm export/lin/*
rm export/win/*
rm export/mac/*
echo Old builds removed . . . 

echo Exporting Linux build . . . 
godot-3.2.1-headless --export "Linux/X11" export/lin/spindle-of-serendipity.run

echo Exporting Windows build
godot-3.2.1-headless --export "Windows Desktop" export/win/spindle-of-serendipity.exe

echo Exporting Mac build
godot-3.2.1-headless --export "Mac OSX" export/mac/spindle-of-serendipity.zip

echo Done!
