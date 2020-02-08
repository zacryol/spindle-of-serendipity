extends HBoxContainer

signal set_alias(import, out)
signal clear_alias(old)

var text : String

func set_text(new_text : String, is_cat : bool):
	text = new_text
	$Import.text = new_text
	if Alias.has(new_text, is_cat):
		var out : String
		if is_cat:
			out = Alias.category(new_text)
		else:
			out = Alias.source(new_text)
		$Input.text = out
		pass


func _on_Add_pressed():
	if $Input.text != "":
		emit_signal("set_alias", text, $Input.text)


func _on_Clear_pressed():
	emit_signal("clear_alias", text)
