extends "res://game/components/GameComponent.gd"

signal pre_reset
onready var p1 := $PanelContainer/VBoxContainer/Player
onready var p2 := $PanelContainer/VBoxContainer/Player2
onready var p3 := $PanelContainer/VBoxContainer/Player3
onready var players_array = [p1, p2, p3]
var current_player = 0

const NUM_PLAYER = 3

func _ready():
	p1.set_name("Player 1")
	p2.set_name("Player 2")
	p3.set_name("Player 3")


func _score_gained(number: int, final: bool):
	players_array[current_player].add_to_score(number)
	emit_signal("game_log", str(number) + " points gained")
	if not final:
		current_player = wrapi(current_player + 1, 0, NUM_PLAYER)
		emit_signal("game_log", players_array[current_player].player_name + " spin!")
	else:
		emit_signal("game_log", "You solved it!")
		emit_signal("pre_reset")


func cache_scores() -> void:
	p1.cache_score()
	p2.cache_score()
	p3.cache_score()


func _on_Player_game_log(text):
	emit_signal("game_log", text)
