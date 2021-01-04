extends "res://game/components/GameComponent.gd"

var score := 0
var total := 0
var player_name: String
var template := "%s: %d (%d)"
var template2 := "%s: %d (%d / %d)"

onready var name_label := $PanelContainer/CenterContainer/VBoxContainer/PlayerLabel
onready var score_label := $PanelContainer/CenterContainer/VBoxContainer/ScoreLabelCurr
onready var total_label := $PanelContainer/CenterContainer/VBoxContainer/TotalLabel

onready var info := $PanelContainer/CenterContainer/InfoLabel as Label

func set_label_text() -> void:
	if GlobalVars.win_by_score():
		info.text = template2 % [player_name, score, total, GlobalVars.win_score]
	else:
		info.text = template % [player_name, score, total]


func add_to_score(points: int) -> void:
	score += points
#	score_label.text = "Score: " + str(score)
	set_label_text()
	
	if GlobalVars.win_by_score():
		if get_all_score() >= GlobalVars.win_score:
			$PanelContainer/CenterContainer.modulate = Color.yellow


func set_name(new_name: String) -> void:
	player_name = new_name
#	name_label.text = player_name
	set_label_text()


func cache_score() -> void:
	total += score
	add_to_score(-score)
#	total_label.text = "Total: " + str(total)
#
#	if GlobalVars.win_by_score():
#		total_label.text += " / " + str(GlobalVars.win_score)


func get_all_score() -> int:
	return score + total
