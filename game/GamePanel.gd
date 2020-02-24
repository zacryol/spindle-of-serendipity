extends Control

onready var entry_display := $GP/VB/Game/HSplit/EDKB/EntryDisplay
onready var log_label := $GP/VB/Top/HB/Label
onready var new_button := $GP/VB/Top/HB/NewG
onready var quit_button := $GP/VB/Top/HB/Quit
onready var spindle := $GP/VB/Game/HSplit/SP/Spindle
onready var players := $GP/VB/Game/HSplit/SP/PlayersPanel
const MAX_LOG_CHAR := 150

func _ready():
	entry_display.set_display(EntryManager.get_random_entry())
	log_label.text = ""
	EntryManager.reset_picked()


func _log(text: String = ""):
	if text == "":
		log_label.text = text
	else:
		var new_text := str(log_label.text) + text + " -- "
		while new_text.length() > MAX_LOG_CHAR:
			new_text = new_text.substr(1)
		log_label.text = new_text


func _on_NewG_pressed():
	players.cache_scores()
	entry_display.set_display(EntryManager.get_random_entry())
	log_label.text = ""
	new_button.hide()
	quit_button.hide()
	spindle.enabled = true


func _pre_reset():
	new_button.show()
	quit_button.show()


func _on_Quit_pressed():
	get_tree().change_scene("res://game/menus/MainMenu.tscn")
