extends Control

var single := preload("res://game/menus/ESSingle.tscn")

onready var vbox := $PC/VBox/Main/Scroll/VBox as VBoxContainer
onready var scroll := $PC/VBox/Main/Scroll as ScrollContainer
onready var add_button := $PC/VBox/Main/Scroll/VBox/AddButton as Button

func _ready() -> void:
	add_item()


func add_item() -> void:
	var s := single.instance()
	vbox.add_child(s)
	vbox.move_child(add_button, vbox.get_child_count() - 1)
	add_button.release_focus()
	yield(get_tree(), "idle_frame")
	scroll.get_v_scrollbar().ratio = 1


func _on_FolderButton_pressed() -> void:
	OS.shell_open(OS.get_user_data_dir() + "/entries")


func _on_AddButton_pressed() -> void:
	add_item()


func _on_MenuButton_pressed() -> void:
	get_tree().change_scene("res://game/menus/MainMenu.tscn")


func _on_SaveButton_pressed() -> void:
	for line in vbox.get_children():
		if line is Button:
			continue
		
		assert(line is PanelContainer)
		
