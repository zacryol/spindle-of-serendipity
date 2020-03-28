extends Control

onready var source_options: OptionButton = $Scroll/List/RevealSource/OptionButton
onready var rand_options: OptionButton= $Scroll/List/RandMode/OptionButton
onready var refr_options: SpinBox = $Scroll/List/Refresh/SpinBox

func _ready():
	source_options.select(GlobalVars.show_source)
	rand_options.select(GlobalVars.rand_mode)
	refr_options.value = GlobalVars.refresh_entries_at


func _on_source_option_selected(id):
	GlobalVars.show_source = id


func _on_rand_option_selected(id):
	GlobalVars.rand_mode = id


func _on_Save_pressed():
	GlobalVars.save_settings_to_file()


func _on_Refresh_value_changed(value):
	GlobalVars.refresh_entries_at = value
