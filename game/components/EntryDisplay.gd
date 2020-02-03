extends "res://game/components/GameComponent.gd"

signal letters_revealed(number, final)

enum {
	MODE_DISABLED
	MODE_ENABLED
}
var current_mode := MODE_DISABLED
var entry_text : String
var bool_mask : Dictionary = {
	"A":false,
	"B":false,
	"C":false,
	"D":false,
	"E":false,
	"F":false,
	"G":false,
	"H":false,
	"I":false,
	"J":false,
	"K":false,
	"L":false,
	"M":false,
	"N":false,
	"O":false,
	"P":false,
	"Q":false,
	"R":false,
	"S":false,
	"T":false,
	"U":false,
	"V":false,
	"W":false,
	"X":false,
	"Y":false,
	"Z":false
}
var placeholder_char := "*"

func _ready():
	pass

func set_display(entry : Entry):
	entry_text = entry.get_entry_text().to_upper()
	
	$CategoryLabel.text = entry.get_game_category()
	$SourceLabel.text = entry.get_game_source()
	$EntryLabel.text = get_display_text()

func get_display_text() -> String:
	var display_text = ""
	for i in entry_text.length():
		var current_char = entry_text.substr(i, 1)
		if bool_mask.has(current_char):
			if bool_mask[current_char]:
				display_text += current_char
			else:
				display_text += placeholder_char
		else:
			display_text += current_char
	return display_text

func is_solved() -> bool:
	return false

func _on_letter_guessed(letter: String):
	if current_mode == MODE_ENABLED:
		var guess = letter.substr(0, 1)
		if !bool_mask.has(guess):
			return 
		if bool_mask[guess] == false:
			bool_mask[guess] = true
			$EntryLabel.text = get_display_text()
			var num := entry_text.countn(guess)
			emit_signal("game_log", str(num) + " revealed")
			emit_signal("letters_revealed", num, is_solved())
			current_mode = MODE_DISABLED
		else:
			emit_signal("game_log", guess + " has already been guessed")
	pass

func _on_Spindle_spun():
	current_mode = MODE_ENABLED
	pass # Replace with function body.
