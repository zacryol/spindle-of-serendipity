extends Control

func _ready():
	EntryImport.grab_saved_files()

func _on_ImportButton_pressed():
	$FileDialog.show()
	pass # Replace with function body.
