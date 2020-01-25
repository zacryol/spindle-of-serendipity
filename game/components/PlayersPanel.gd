extends Control

onready var p1 := $PanelContainer/VBoxContainer/Player
onready var p2 := $PanelContainer/VBoxContainer/Player2
onready var p3 := $PanelContainer/VBoxContainer/Player3
onready var players_array = [p1, p2, p3]
var current_player = 0

const NUM_PLAYER = 3

func _ready():
	pass

func _letters_guessed(number: int):
	players_array[current_player].add_to_score(number)
	current_player = wrapi(current_player + 1, 0, NUM_PLAYER)
	pass
