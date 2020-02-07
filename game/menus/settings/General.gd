extends Tabs

onready var source_options := $Scroll/List/RevealSource/OptionButton
onready var rand_options := $Scroll/List/RandMode/OptionButton


func _ready():
	source_options.select(GlobalVars.show_source)
	rand_options.select(GlobalVars.rand_mode)
	pass


func _on_source_option_selected(id):
	pass # Replace with function body.


func _on_rand_option_selected(id):
	pass # Replace with function body.
