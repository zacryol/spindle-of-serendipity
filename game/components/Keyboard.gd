extends "res://game/components/GameComponent.gd"

onready var key_container := $CenterContainer/GridContainer
signal key_pressed(letter)

func _ready():
	var keys := key_container.get_children()
	for key in keys:
		if key is Button:
			key.connect("pressed", self, "_on_Key_pressed", [key.text])


func guess_letter(letter : String):
	emit_signal("key_pressed", letter)
	if get_button(letter):
		get_button(letter).disabled = true


func _on_Key_pressed(letter : String):
	guess_letter(letter)


func _input(event):
	if event is InputEventKey \
			&& event.scancode in range(KEY_A, KEY_Z + 1) \
			&& not event.is_echo() \
			&& event.is_pressed():
		var e := str(event.as_text().right(event.as_text().length() - 1))
		guess_letter(e)


func get_button(letter : String) -> Button:
	for key in key_container.get_children():
		if key is Button:
			if key.text == letter:
				return key
	return null
