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

var core_text: String = ""

func _ready():
	pass
