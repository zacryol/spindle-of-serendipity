extends Control

onready var entry_display := $PanelContainer/VBoxContainer/PanelContainer2/HSplitContainer/VSplitContainer/EntryDisplay


func _ready():
	entry_display.set_display(EntryManager.get_random_entry())
	
	pass
