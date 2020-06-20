extends "res://game/components/GameComponent.gd"

var score := 0
var total := 0
var player_name: String

onready var name_label := $PanelContainer/CenterContainer/VBoxContainer/PlayerLabel
onready var score_label := $PanelContainer/CenterContainer/VBoxContainer/ScoreLabelCurr
onready var total_label := $PanelContainer/CenterContainer/VBoxContainer/TotalLabel

func add_to_score(points: int) -> void:
	score += points
	score_label.text = "Score: " + str(score)


func set_name(new_name: String) -> void:
	player_name = new_name
	name_label.text = player_name


func cache_score() -> void:
	total += score
	add_to_score(-score)
	total_label.text = "Total: " + str(total)
	
	if GlobalVars.game_type == GlobalVars.Type.SCORE:
		total_label.text += " / " + str(GlobalVars.win_score)


func get_all_score() -> int:
	return score + total
