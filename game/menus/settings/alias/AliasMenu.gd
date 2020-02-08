extends Tabs

onready var cat := $T/Categories
onready var sou := $T/Sources

func _ready():
	cat.set_ui(true)
	sou.set_ui(false)
