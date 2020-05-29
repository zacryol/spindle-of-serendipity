extends Control

onready var source_options: OptionButton = $Scroll/List/RevealSource/OptionButton
onready var rand_options: OptionButton= $Scroll/List/RandMode/OptionButton
onready var refr_options: SpinBox = $Scroll/List/Refresh/SpinBox

func _ready():
	source_options.select(GlobalVars.settings["source"])
	rand_options.select(GlobalVars.settings["rand"])
	refr_options.value = GlobalVars.settings["refresh"]


func _on_source_option_selected(id):
	GlobalVars.settings["source"] = id


func _on_rand_option_selected(id):
	GlobalVars.settings["rand"] = id


func _on_Save_pressed():
	GlobalVars.save_settings_to_file()


func _on_Refresh_value_changed(value):
	GlobalVars.settings["refresh"] = value
