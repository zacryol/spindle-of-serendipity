extends "res://game/components/GameComponent.gd"

signal key_pressed(letter)

func _ready():
	var key_container := $CenterContainer/GridContainer
	var keys := key_container.get_children()
	for key in keys:
		if key is Button:
			key.connect("pressed", self, "_on_Key_pressed", [key.text])


func _on_Key_pressed(letter : String):
	emit_signal("key_pressed", letter)


func _input(event):
	if event is InputEventKey \
			&& event.scancode in range(KEY_A, KEY_Z + 1) \
			&& not event.is_echo() \
			&& event.is_pressed():
		var e := str(event.as_text().right(event.as_text().length() - 1))
		emit_signal("key_pressed", e)
