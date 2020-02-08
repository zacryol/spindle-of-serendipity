extends HBoxContainer

signal set_alias(out)
signal clear_alias

var text : String setget set_text

func set_text(new_text : String):
	text = new_text
	$Import.text = new_text


func _on_Add_pressed():
	pass # Replace with function body.


func _on_Clear_pressed():
	pass # Replace with function body.
