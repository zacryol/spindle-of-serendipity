extends TextureRect

enum State {
	BLOCKED,
	REVEALED,
	TEMP,
}

const COLOR_REVEALED = Color(0.32, 0.65, 1.00, 1.00)
const COLOR_BLOCKED = Color.black
const COLOR_TEMP = Color.red
const COLOR_NONE = Color.white

var core_text: String = "" setget set_core, get_core
var current_state: int = State.BLOCKED setget set_state, get_state

func _ready():
	pass


func set_core(new_core: String):
	core_text = new_core.substr(0, 1)


func get_core() -> String:
	return core_text


func set_state(new: int):
	match new:
		State.BLOCKED:
			self_modulate = COLOR_BLOCKED
			$Label.text = ""
		State.REVEALED:
			self_modulate = COLOR_REVEALED
			$Label.text = core_text
		State.TEMP:
			self_modulate = COLOR_TEMP


func get_state() -> int:
	return current_state


func temp(guess: String) -> void:
	set_state(State.TEMP)
	$Label.text = guess.substr(0, 1)
