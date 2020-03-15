extends Control

onready var p1_enter := $VBoxContainer/LineEdit
onready var p2_enter := $VBoxContainer/LineEdit2
onready var p3_enter := $VBoxContainer/LineEdit3

func _on_Button_pressed():
	if p1_enter.text:
		GlobalVars.p1_name = p1_enter.text
	else:
		GlobalVars.p1_name = GlobalVars.p1_name_default
	if p2_enter.text:
		GlobalVars.p2_name = p2_enter.text
	else:
		GlobalVars.p2_name = GlobalVars.p2_name_default
	if p3_enter.text:
		GlobalVars.p3_name = p3_enter.text
	else:
		GlobalVars.p3_name = GlobalVars.p3_name_default
	get_tree().change_scene("res://game/GamePanel.tscn")
