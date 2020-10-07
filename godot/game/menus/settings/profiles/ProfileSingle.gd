extends PanelContainer

var core_text: String
onready var check: CheckBox = $CheckBox

func set_text(main: String, alias: String = "") -> void:
	core_text = main
	check.text = main + alias


func get_core() -> String:
	return core_text


func checked() -> bool:
	return check.pressed


func set_checked(checked: bool = true) -> void:
	check.pressed = checked
