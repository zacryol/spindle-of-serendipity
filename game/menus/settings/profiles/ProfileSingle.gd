extends PanelContainer

var core_text: String

func set_text(main: String, alias: String = "") -> void:
	core_text = main
	$CheckBox.text = main + alias


func get_core() -> String:
	return core_text


func checked() -> bool:
	return $CheckBox.pressed
