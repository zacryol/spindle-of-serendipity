tool
extends TextureRect

export var text: String setget set_text

func _ready():
	pass


func set_text(tex: String):
	$Label.text = tex.substr(0, 1)
