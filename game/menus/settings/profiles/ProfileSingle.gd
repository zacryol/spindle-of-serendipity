extends PanelContainer

var core_text: String

func _ready():
	pass


func set_text(main: String, alias: String = "") -> void:
	core_text = main
	$CheckBox.text = main + alias


func get_core() -> String:
	return core_text
