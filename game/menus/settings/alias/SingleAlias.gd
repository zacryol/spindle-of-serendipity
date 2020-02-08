extends HBoxContainer

var text : String setget set_text

func _ready():
	pass


func set_text(new_text : String):
	text = new_text
	$Import.text = new_text
