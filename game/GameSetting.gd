extends Control

onready var p1_enter := $VBoxContainer/LineEdit
onready var p2_enter := $VBoxContainer/LineEdit2
onready var p3_enter := $VBoxContainer/LineEdit3

func _on_Button_pressed():
	if p1_enter.text:
		GlobalVars.p1_name = p1_enter.text
	if p2_enter.text:
		GlobalVars.p2_name = p2_enter.text
	if p3_enter.text:
		GlobalVars.p3_name = p3_enter.text
	get_tree().change_scene("res://game/GamePanel.tscn")
