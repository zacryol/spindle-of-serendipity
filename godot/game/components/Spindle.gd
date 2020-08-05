extends "res://game/components/GameComponent.gd"

signal score(points, final)
signal spun

enum State {
	INACTIVE, # Not enabled. Something else needs to be done.
	ACTIVE, # Enabled. Player needs to click
	RUNNING, # Spinning. Click to set score
}

var current_state: int = State.INACTIVE

var current_value: int
var enabled := false setget set_enabled

func set_enabled(enab: bool) -> void:
	enabled = enab
	$Button.disabled = not enabled
	print("SHOULD NOT HAPPEN")


func set_state(new_state: int) -> void:
	current_state = new_state
	match new_state:
		State.INACTIVE:
			$Button.disabled = true
		State.ACTIVE:
			$Button.disabled = false


func _letters_guessed(number: int, solves: bool):
	#self.enabled = false
	set_state(State.INACTIVE)
	emit_signal("score", number * current_value, solves)


func _on_Button_pressed():
	#if enabled:
	#	pass
	if current_state == State.ACTIVE:
		emit_signal("game_log", "")
		current_value = (randi() % 10 + 1) * 5
		$ScoringLabel.text = "Score: " + str(current_value)
		#self.enabled = false
		set_state(State.INACTIVE)
		emit_signal("game_log", str(current_value) + " points per letter")
		emit_signal("spun")


func _on_PlayersPanel_turn_done():
	#self.enabled = true
	set_state(State.ACTIVE)


func _on_EntryDisplay_text_ready():
	#self.enabled = true
	set_state(State.ACTIVE)
