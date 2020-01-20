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
		EntryImport.import_entries_from_file(path)
		
		var file_name = Array(path.split("/")).back()
		var save_path = GlobalVars.ENTRIES_SAVE + file_name
		if File.new().file_exists(save_path):
			pass
		Directory.new().copy(path, save_path)
	
	pass # Replace with function body.
