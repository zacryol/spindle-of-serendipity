extends PanelContainer

signal move_request(direction)

onready var entry_enter := $HBoxContainer/E as LineEdit
onready var cat_enter := $HBoxContainer/C as LineEdit
onready var sou_enter := $HBoxContainer/S as LineEdit
onready var try_delete := $HBoxContainer/DeleteButton as Button
onready var del_conf := $HBoxContainer/DelConf as HBoxContainer
onready var up := $HBoxContainer/UpButton as Button
onready var down := $HBoxContainer/DownButton as Button

func _ready() -> void:
	pass


func get_text() -> String:
	return entry_enter.text


func get_category() -> String:
	return cat_enter.text


func get_source() -> String:
	return sou_enter.text


func set_values(e := "", c := "", s := "") -> void:
	entry_enter.text = e
	cat_enter.text = c
	sou_enter.text = s


func _on_DeleteButton_pressed() -> void:
	try_delete.hide()
	del_conf.show()


func _on_Yes_pressed() -> void:
	queue_free()


func _on_No_pressed() -> void:
	try_delete.show()
	del_conf.hide()


func _on_UpButton_pressed() -> void:
	emit_signal("move_request", -1)
	up.release_focus()


func _on_DownButton_pressed() -> void:
	emit_signal("move_request", 1)
	down.release_focus()
