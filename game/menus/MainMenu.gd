extends Control

func _ready():
	EntryImport.grab_saved_files()

func _on_ImportButton_pressed():
	$FileDialog.current_dir = "res://"
	$FileDialog.current_path = "res://"
	$FileDialog.show()
	pass # Replace with function body.

func _on_FileDialog_files_selected(paths):
	for path in paths:
		var file_name = Array((path as String).split("/")).back()
		EntryImport.import_entries_from_file(path)
		Directory.new().copy(path, GlobalVars.ENTRIES_SAVE + file_name)
	
	pass # Replace with function body.
