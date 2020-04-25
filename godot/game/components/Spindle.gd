extends "res://game/components/GameComponent.gd"

signal score(points, final)
signal spun

var current_value: int
var enabled := false setget set_enabled

func set_enabled(enab: bool) -> void:
	enabled = enab
	$Button.disabled = not enabled


func _letters_guessed(number: int, solves: bool):
	self.enabled = false
	emit_signal("score", number * current_value, solves)


func _on_Button_pressed():
	if enabled:
		emit_signal("game_log", "")
		current_value = (randi() % 10 + 1) * 5
		$ScoringLabel.text = "Score: " + str(current_value)
		self.enabled = false
		emit_signal("game_log", str(current_value) + " points per letter")
		emit_signal("spun")


func _on_PlayersPanel_turn_done():
	self.enabled = true


func _on_EntryDisplay_text_ready():
	self.enabled = true
