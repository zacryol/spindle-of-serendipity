extends Control

const MAX_LOG_CHAR := 120

var round_num := 0

onready var entry_display := $GP/VB/Game/HSplit/EDKB/EntryDisplay
onready var log_label: Label = $GP/VB/Top/HB/Label
onready var new_button: Button = $GP/VB/Top/HB/NewG
onready var quit_button: Button = $GP/VB/Top/HB/Quit
onready var spindle := $GP/VB/Game/HSplit/SP/Spindle
onready var players := $GP/VB/Game/HSplit/SP/PlayersPanel
onready var keyboard := $GP/VB/Game/HSplit/EDKB/Keyboard

func _ready():
	EntryManager.reset_picked()	
	start()


func start() -> void:
	entry_display.set_display(EntryManager.get_random_entry())
	round_num += 1
	log_label.text = ""
	players.start()
	new_button.hide()
	quit_button.hide()
	keyboard.enable()


func total_win() -> bool:
	match GlobalVars.game_type:
		GlobalVars.Type.ROUNDS:
			# check round num
			return round_num >= GlobalVars.rounds
			pass
		GlobalVars.Type.SCORE:
			# check player scores
			return players.highest_score() >= GlobalVars.win_score
			pass
		GlobalVars.Type.FREE:
			# keep going anyway
			return false
	return false


func _log(text: String = ""):
	if text == "":
		log_label.text = text
	else:
		var new_text := str(log_label.text) + text + " -- "
		while new_text.length() > MAX_LOG_CHAR:
			new_text = new_text.substr(1)
		log_label.text = new_text


func _on_NewG_pressed():
	if total_win():
		pass
	else:
		start()


func _pre_reset():
	new_button.show()
	quit_button.show()


func _on_Quit_pressed():
	get_tree().change_scene("res://game/menus/MainMenu.tscn")
