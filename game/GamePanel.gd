extends Control

onready var entry_display := $PanelContainer/VBoxContainer/PanelContainer2/HSplitContainer/VSplitContainer/EntryDisplay
onready var log_label := $PanelContainer/VBoxContainer/PanelContainer/Label

func _ready():
	entry_display.set_display(EntryManager.get_random_entry())
	
	pass

func _log(text: String):
	log_label.text = text
