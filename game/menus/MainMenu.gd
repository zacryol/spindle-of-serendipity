extends Control

func _ready():
	EntryImport.grab_saved_files()

func _on_ImportButton_pressed():
	$FileDialog.current_dir = "res://"
	$FileDialog.current_path = "res://"
	$FileDialog.show()
	pass # Replace with function body.
