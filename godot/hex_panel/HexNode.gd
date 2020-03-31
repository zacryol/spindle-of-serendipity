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

func _ready():
	pass


func set_core(new_core: String):
	core_text = new_core.substr(0, 1)


func get_core() -> String:
	return core_text
