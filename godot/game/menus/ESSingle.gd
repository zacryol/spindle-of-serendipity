extends PanelContainer

onready var entry_label := $HBoxContainer/Label as Label
onready var cat_label := $HBoxContainer/Label2 as Label
onready var sou_label := $HBoxContainer/Label3 as Label

func _ready() -> void:
	pass


func get_text() -> String:
	return entry_label.text


func get_category() -> String:
	return cat_label.text


func get_source() -> String:
	return sou_label.text
