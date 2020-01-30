extends "res://game/components/GameComponent.gd"

var score: int = 0
onready var score_label = $PanelContainer/CenterContainer/VBoxContainer/ScoreLabelCurr
var player_name: String
onready var name_label := $PanelContainer/CenterContainer/VBoxContainer/PlayerLabel

func _ready():
	pass

func add_to_score(points: int) -> void:
	score += points
	score_label.text = "Score: " + str(score)
	pass

func set_name(new_name: String) -> void:
	player_name = new_name
	name_label.text = player_name
