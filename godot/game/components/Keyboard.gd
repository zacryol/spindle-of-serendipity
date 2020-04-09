extends "res://game/components/GameComponent.gd"

signal key_pressed(letter)
onready var key_container: GridContainer = $CenterContainer/GridContainer

func _ready():
	# Setup Keys
	for c in CharSet.CHAR_MAIN.size():
		var b := Button.new()
		b.text = CharSet.CHAR_MAIN[c]
		key_container.add_child(b)
	
	
	
	var keys := key_container.get_children()
	for key in keys:
		if key is Button:
			key.connect("pressed", self, "_on_Key_pressed", [key.text])


func _input(event):
	if event is InputEventKey \
			&& event.scancode in range(KEY_A, KEY_Z + 1) \
			&& not event.is_echo() \
			&& event.is_pressed():
		var e := str(event.as_text().right(event.as_text().length() - 1))
		guess_letter(e)


func guess_letter(letter: String):
	emit_signal("key_pressed", letter)


func get_button(letter: String) -> Button:
	for key in key_container.get_children():
		if key is Button:
			if key.text == letter:
				return key
	return null


func enable() -> void:
	for key in key_container.get_children():
		if key is Button:
			key.disabled = false


func _on_Key_pressed(letter: String):
	guess_letter(letter)


func _on_EntryDisplay_one_letter(letter):
	if get_button(letter):
		get_button(letter).disabled = true
