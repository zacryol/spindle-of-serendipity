extends Control

var current_profile := ""
var single := preload("res://game/menus/settings/profiles/ProfileSingle.tscn")
onready var categories := $VBoxContainer/Config/Categories/SC/List
onready var sources := $VBoxContainer/Config/Sources/SC/List

func _ready():
	for cat in EntryManager.get_import_categories():
		var l := single.instance()
		var new_text: String = cat
		if Alias.has(cat, true):
			new_text += " -> " + Alias.category(cat).to_lower()
		l.set_text(new_text)
		categories.add_child(l)
	
	for sou in EntryManager.get_import_sources():
		var l := single.instance()
		var new_text: String = sou
		if Alias.has(sou, false):
			new_text += " -> " + Alias.source(sou).to_lower()
		l.set_text(new_text)
		sources.add_child(l)
	pass
