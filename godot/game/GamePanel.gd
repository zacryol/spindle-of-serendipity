extends Control

const MAX_LOG_CHAR := 120
onready var entry_display := $GP/VB/Game/HSplit/EDKB/EntryDisplay
onready var log_label := $GP/VB/Top/HB/Label
onready var new_button := $GP/VB/Top/HB/NewG
onready var quit_button := $GP/VB/Top/HB/Quit
onready var spindle := $GP/VB/Game/HSplit/SP/Spindle
onready var players := $GP/VB/Game/HSplit/SP/PlayersPanel
onready var keyboard := $GP/VB/Game/HSplit/EDKB/Keyboard

func _ready():
	EntryManager.reset_picked()
	
	entry_display.set_display(EntryManager.get_random_entry())
	log_label.text = ""
	
	players.start()


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
	players.start()
	new_button.hide()
	quit_button.hide()
	keyboard.enable()
	spindle.enabled = true


func _pre_reset():
	new_button.show()
	quit_button.show()


func _on_Quit_pressed():
	get_tree().change_scene("res://game/menus/MainMenu.tscn")