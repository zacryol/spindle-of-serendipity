extends Control

var score: int = 0
onready var score_label = $PanelContainer/CenterContainer/VBoxContainer/ScoreLabelCurr

func _ready():
	pass

func add_to_score(points: int) -> void:
	score += points
	score_label.text = "Score: " + str(score)
	pass
