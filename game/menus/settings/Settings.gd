extends Control


func _ready():
	pass


func _on_Back_pressed():
	get_tree().change_scene("res://game/menus/MainMenu.tscn")
