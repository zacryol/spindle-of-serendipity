extends "res://game/components/GameComponent.gd"

signal pre_reset
signal turn_done

const NUM_PLAYER := 3
var current_player := 0

onready var p1 := $PanelContainer/VBoxContainer/Player
onready var p2 := $PanelContainer/VBoxContainer/Player2
onready var p3 := $PanelContainer/VBoxContainer/Player3
onready var players_array := [p1, p2, p3]
onready var p_label: Label = $PanelContainer/VBoxContainer/PanelContainer/Label
onready var solve_box := $ConfirmationDialog


func _ready():
	solve_box.get_cancel().connect("pressed", self, "_on_ConfirmationDialog_canceled")
	solve_box.get_close_button().hide()
	p1.set_name(GlobalVars.p1_name)
	p2.set_name(GlobalVars.p2_name)
	p3.set_name(GlobalVars.p3_name)
	current_player = randi() % NUM_PLAYER
	
	set_label()


func start():
	emit_signal("game_log", get_current_player().player_name + " go!")
	cache_scores()
	set_label()


func _score_gained(number: int, final: bool):
	get_current_player().add_to_score(number)
	emit_signal("game_log", str(number) + " points gained")
	if final:
		emit_signal("game_log", "You solved it!")
		emit_signal("pre_reset")
		advance_player()
		clear_label()
	else:
		solve_box.show()
#		pass_turn()


func pass_turn() -> void:
	advance_player()
	emit_signal("game_log", get_current_player().player_name + " spin!")
	emit_signal("turn_done")


func cache_scores() -> void:
	p1.cache_score()
	p2.cache_score()
	p3.cache_score()


func get_current_player():
	return players_array[current_player]


func advance_player():
	current_player = wrapi(current_player + 1, 0, NUM_PLAYER)
	set_label()


func set_label():
	p_label.text = get_current_player().player_name + "'s turn!"


func clear_label():
	p_label.text = ""


func _on_Player_game_log(text: String):
	emit_signal("game_log", text)


func _on_ConfirmationDialog_confirmed():
	# Inititalize Solve
	pass_turn() # Temp


func _on_ConfirmationDialog_canceled():
	pass_turn()
