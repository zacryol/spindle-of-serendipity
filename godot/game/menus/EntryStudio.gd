extends Control


func _ready():
	pass


func _on_FolderButton_pressed():
	OS.shell_open(OS.get_user_data_dir() + "/entries")
