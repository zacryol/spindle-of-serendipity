extends PanelContainer

onready var entry_enter := $HBoxContainer/E as LineEdit
onready var cat_enter := $HBoxContainer/C as LineEdit
onready var sou_enter := $HBoxContainer/S as LineEdit

func _ready() -> void:
	pass


func get_text() -> String:
	return entry_enter.text


func get_category() -> String:
	return cat_enter.text


func get_source() -> String:
	return sou_enter.text
