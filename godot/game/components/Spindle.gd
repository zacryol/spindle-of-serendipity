extends "res://game/components/GameComponent.gd"

signal score(points, final)
signal spun

enum State {
	INACTIVE, # Not enabled. Something else needs to be done.
	ACTIVE, # Enabled. Player needs to click
	RUNNING, # Spinning. Click to set score
}

onready var anim: AnimationPlayer = $AnimationPlayer
onready var scores: Control = $SpindleScores
onready var bt: Button = $Button

var current_state: int = State.INACTIVE
var current_value: int


func set_state(new_state: int) -> void:
	current_state = new_state
	match new_state:
		State.INACTIVE:
			bt.disabled = true
			bt.text = "Spin!"
		State.ACTIVE:
			bt.disabled = false
			bt.text = "Spin!"
		State.RUNNING:
			bt.disabled = true
			yield(get_tree().create_timer(0.5), "timeout")
			bt.disabled = false
			bt.text = "Strike!"


func _letters_guessed(number: int, solves: bool):
	set_state(State.INACTIVE)
	emit_signal("score", number * current_value, solves)


func _on_Button_pressed():
	match current_state:
		State.ACTIVE:
			set_state(State.RUNNING)
			anim.play("Back")
			scores.start()
		State.RUNNING:
			emit_signal("game_log", "")
			anim.play("Forward")
			yield(anim, "animation_finished")
			current_value = scores.stop()
			set_state(State.INACTIVE)
			emit_signal("game_log", str(current_value) + " points per letter")
			emit_signal("spun")


func _on_PlayersPanel_turn_done():
	set_state(State.ACTIVE)


func _on_EntryDisplay_text_ready():
	set_state(State.ACTIVE)
