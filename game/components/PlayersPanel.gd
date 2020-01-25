extends Control

onready var p1 := $PanelContainer/VBoxContainer/Player
onready var p2 := $PanelContainer/VBoxContainer/Player2
onready var p3 := $PanelContainer/VBoxContainer/Player3
onready var players_array = [p1, p2, p3]
var current_player = 0

# Maximum INDEX, not quantity
const MAX_PLAYER = 2

func _ready():
	pass

func _letters_guessed(number: int):
	players_array[current_player].score += number
	pass
