extends Control

const MAX_LOG_CHAR := 120

var round_num := 0

onready var entry_display := $GP/VB/Game/HSplit/EDKB/EntryDisplay
onready var log_label: Label = $GP/VB/Top/HB/Label
onready var new_button: Button = $GP/VB/Top/HB/NewG
onready var spindle := $GP/VB/Game/HSplit/SP/Spindle
onready var players := $GP/VB/Game/Arrange/PlayersPanel
onready var keyboard := $GP/VB/Game/Arrange/Keyboard
onready var victory := $VScreen
onready var round_sign := $RoundSign
onready var quit_confirm: ConfirmationDialog = $QuitConfirm/Main/ConfirmationDialog

func _ready() -> void:
	EntryManager.reset_picked()
	start()
	quit_confirm.get_cancel().connect("pressed", self, "_on_QuitConfirm_exit")
	quit_confirm.get_close_button().hide()


func start() -> void:
	entry_display.set_display(EntryManager.get_random_entry())
	round_num += 1
	round_sign.new_round(round_num)
	log_label.text = ""
	players.start()
	new_button.hide()
	keyboard.enable()


func total_win() -> bool:
	if GlobalVars.win_by_score():
		if players.highest_score() >= GlobalVars.win_score:
			return true
	
	if GlobalVars.win_by_rounds():
		if round_num >= GlobalVars.rounds:
			return true
	
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
		victory.show()
		victory.set_results(players.get_final_results())
	else:
		start()


func _pre_reset():
	new_button.show()


func _on_Quit_pressed():
	$QuitConfirm/Main.show()
	quit_confirm.show()


func _on_QuitConfirm_confirmed():
	get_tree().change_scene("res://game/menus/MainMenu.tscn")


func _on_QuitConfirm_exit():
	$QuitConfirm/Main.hide()
