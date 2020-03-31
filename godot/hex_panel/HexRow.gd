tool
extends HBoxContainer

export var line_text: String setget set_line, get_line

var HexNode: PackedScene = preload("res://hex_panel/HexNode.tscn")

func _ready():
	pass


func set_line(text: String):
	print(text.length())


func get_line() -> String:
	return line_text
