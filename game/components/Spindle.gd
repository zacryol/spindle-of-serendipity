extends Control

var current_value : int

func _ready():
	pass


func _on_Button_pressed():
	current_value = (randi() % 10 + 1) * 5
	$ScoringLabel.text = "Score: " + str(current_value)
