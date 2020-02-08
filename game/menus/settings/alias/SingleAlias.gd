extends HBoxContainer

signal set_alias(import, out)
signal clear_alias(old)

var text : String setget set_text

func set_text(new_text : String):
	text = new_text
	$Import.text = new_text


func _on_Add_pressed():
	if $Input.text != "":
		emit_signal("set_alias", text, $Input.text)


func _on_Clear_pressed():
	emit_signal("clear_alias", text)
