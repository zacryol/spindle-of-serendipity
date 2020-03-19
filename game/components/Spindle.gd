extends "res://game/components/GameComponent.gd"

signal score(points, final)
signal spun

var current_value: int
var enabled := true

func _letters_guessed(number: int, solves: bool):
	emit_signal("score", number * current_value, solves)
	enabled = false


func _on_Button_pressed():
	if enabled:
		emit_signal("game_log", "")
		current_value = (randi() % 10 + 1) * 5
		$ScoringLabel.text = "Score: " + str(current_value)
		enabled = false
		emit_signal("game_log", str(current_value) + " points per letter")
		emit_signal("spun")


func _on_PlayersPanel_turn_done():
	enabled = true
