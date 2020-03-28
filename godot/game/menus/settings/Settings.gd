extends Control


func _ready():
	$PanelContainer/TabContainer.current_tab = 1


func _on_Back_pressed():
	get_tree().change_scene("res://game/menus/MainMenu.tscn")
