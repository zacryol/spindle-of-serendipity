extends "res://game/components/GameComponent.gd"

signal pre_reset
onready var p1 := $PanelContainer/VBoxContainer/Player
onready var p2 := $PanelContainer/VBoxContainer/Player2
onready var p3 := $PanelContainer/VBoxContainer/Player3
onready var players_array := [p1, p2, p3]
var current_player := 0

onready var p_label : Label = $PanelContainer/VBoxContainer/PanelContainer/Label

const NUM_PLAYER = 3

func _ready():
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
	advance_player()
	if not final:
		emit_signal("game_log", get_current_player().player_name + " spin!")
	else:
		emit_signal("game_log", "You solved it!")
		emit_signal("pre_reset")
		clear_label()


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


func _on_Player_game_log(text):
	emit_signal("game_log", text)
