extends Control

signal key_pressed(letter)

func _ready():
	var key_container := $CenterContainer/GridContainer
	var keys := key_container.get_children()
	for key in keys:
		(key as Button).connect("pressed", self, "_on_Key_pressed", [key.text])
		pass
	pass

func _on_Key_pressed(letter : String):
	emit_signal("key_pressed", letter)
	pass
