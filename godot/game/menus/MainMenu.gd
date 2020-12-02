extends Control

func _ready():
	pass


func _on_ImportButton_pressed():
	$FileDialog.current_dir = OS.get_executable_path().get_base_dir()
	$FileDialog.show()


func _on_FileDialog_files_selected(paths: PoolStringArray):
	for path in paths:
		EntryImport.import_entries_from_file(path)
		
		var file_name := str(path).get_file()
		var save_path := str(GlobalVars.ENTRIES_SAVE + file_name)
		if File.new().file_exists(save_path):
			var copy := 0
			var new_file_path: String
			var f := File.new()
			while f.file_exists(save_path):
				new_file_path = str(copy) + file_name
				save_path = str(GlobalVars.ENTRIES_SAVE + new_file_path)
				copy += 1
		Directory.new().copy(path, save_path)


func _on_StartButton_pressed():
	if EntryManager.entries.size() == 0:
		$AcceptDialog.show()
	else:
		get_tree().change_scene("res://game/GameSetting.tscn")


func _on_Settings_pressed():
	get_tree().change_scene("res://game/menus/settings/Settings.tscn")


func _on_EButton_pressed():
	get_tree().change_scene("res://game/menus/EntryStudio.tscn")
