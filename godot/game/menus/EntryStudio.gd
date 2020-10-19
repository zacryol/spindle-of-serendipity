extends Control

var single := preload("res://game/menus/ESSingle.tscn")

onready var vbox: VBoxContainer = $PanelContainer/HSplitContainer/ScrollContainer/VBoxContainer
onready var add_button: Button = $PanelContainer/HSplitContainer/ScrollContainer/VBoxContainer/AddButton

func _ready():
	add_item()


func add_item():
	var s := single.instance()
	vbox.add_child(s)
	vbox.move_child(add_button, vbox.get_child_count() - 1)


func _on_FolderButton_pressed():
	OS.shell_open(OS.get_user_data_dir() + "/entries")


func _on_AddButton_pressed():
	add_item()
