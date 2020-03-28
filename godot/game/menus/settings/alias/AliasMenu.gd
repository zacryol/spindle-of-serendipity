extends Control

onready var cat := $Categories
onready var sou := $Sources

func _ready():
	cat.set_ui(true)
	sou.set_ui(false)
