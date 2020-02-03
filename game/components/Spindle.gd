extends "res://game/components/GameComponent.gd"

var current_value : int
signal score(points)
signal spun
var enabled := true

func _ready():
	pass

func _letters_guessed(number: int, solves: bool):
	emit_signal("score", number * current_value)
	enabled = true

func _on_Button_pressed():
	if enabled:
		emit_signal("game_log", "")
		current_value = (randi() % 10 + 1) * 5
		$ScoringLabel.text = "Score: " + str(current_value)
		enabled = false
		emit_signal("game_log", str(current_value) + " points per letter")
		emit_signal("spun")
