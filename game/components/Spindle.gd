extends Control

var current_value : int
signal score(points)
signal spun
var enabled := true

func _ready():
	pass

func _letters_guessed(number: int):
	emit_signal("score", number * current_value)
	enabled = true

func _on_Button_pressed():
	if enabled:
		current_value = (randi() % 10 + 1) * 5
		$ScoringLabel.text = "Score: " + str(current_value)
		enabled = false
		emit_signal("spun")
