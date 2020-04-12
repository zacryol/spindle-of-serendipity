extends TextureRect

enum State {
	BLOCKED,
	REVEALED,
	TEMP,
	EMPTY,
}

const COLOR_REVEALED = Color(0.32, 0.65, 1.00, 1.00)
const COLOR_BLOCKED = Color.black
const COLOR_TEMP = Color.mediumseagreen
const COLOR_NONE = Color.transparent

var text: String = "" setget set_text, get_text
var current_state: int = State.BLOCKED setget set_state, get_state

onready var view: Label = $Label

func _ready():
	pass


func set_text(new_text: String):
	text = new_text.substr(0, 1)
	if current_state == State.REVEALED:
		view.text = text
	
	if text == " ":
		set_state(State.EMPTY)
	elif not CharSet.has(text):
		set_state(State.REVEALED)
	else:
		set_state(State.BLOCKED)


func get_text() -> String:
	return text


func set_state(new: int):
	var changed := new != current_state
	
	if text == " ":
		current_state = State.EMPTY
	else:
		current_state = new
	
	match current_state:
		State.BLOCKED:
			modulate = COLOR_BLOCKED
			view.text = ""
		State.REVEALED:
			modulate = COLOR_REVEALED
			view.text = text
		State.TEMP:
			modulate = COLOR_TEMP
		State.EMPTY:
			view.text = ""
			modulate = COLOR_NONE
	if changed:
		$AnimationPlayer.play("change")

func get_state() -> int:
	return current_state


func temp(guess: String) -> void:
	set_state(State.TEMP)
	view.text = guess.substr(0, 1)


func verify() -> bool:
	match current_state:
		State.REVEALED:
			return true
		State.EMPTY:
			return true
		State.BLOCKED:
			return false
		State.TEMP:
			return CharSet.compare(view.text, text)
	
	return false
