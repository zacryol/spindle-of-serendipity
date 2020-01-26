extends Control

var current_value : int
signal score(points)

func _ready():
	pass

func _letters_guessed(number: int):
	emit_signal("score", number * current_value)

func _on_Button_pressed():
	current_value = (randi() % 10 + 1) * 5
	$ScoringLabel.text = "Score: " + str(current_value)
