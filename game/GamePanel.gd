extends Control

onready var entry_display := $GP/VBoxContainer/Game/HSplit/EDKB/EntryDisplay
onready var log_label := $GP/VBoxContainer/Top/HBoxContainer/Label
onready var new_button := $GP/VBoxContainer/Top/HBoxContainer/NewG
onready var spindle := $GP/VBoxContainer/Game/HSplit/SP/Spindle
const MAX_LOG_CHAR := 150

func _ready():
	entry_display.set_display(EntryManager.get_random_entry())
	log_label.text = ""
	pass

func _log(text: String = ""):
	if text == "":
		log_label.text = text
	else:
		var new_text := str(log_label.text) + text + " -- "
		while new_text.length() > MAX_LOG_CHAR:
			new_text = new_text.substr(1)
		log_label.text = new_text

func _on_NewG_pressed():
	entry_display.set_display(EntryManager.get_random_entry())
	log_label.text = ""
	new_button.hide()
	spindle.enabled = true
	pass # Replace with function body.

func _pre_reset():
	new_button.show()
