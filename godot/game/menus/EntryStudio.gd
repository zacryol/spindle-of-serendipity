extends Control

var single := preload("res://game/menus/ESSingle.tscn")

onready var vbox := $PC/HSplit/PContainer/Scroll/VBox as VBoxContainer
onready var add_button := $PC/HSplit/PContainer/Scroll/VBox/AddButton as Button

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
