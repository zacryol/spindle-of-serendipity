extends Control

var current_profile := ""
var single := preload("res://game/menus/settings/profiles/ProfileSingle.tscn")
onready var categories := $VBoxContainer/Config/Categories/SC/List
onready var sources := $VBoxContainer/Config/Sources/SC/List
onready var save_name: LineEdit = $VBoxContainer/Top/LineEdit
onready var alert := $SaveName
onready var load_button: MenuButton = $VBoxContainer/Top/LoadButton

func _ready():
	for cat in EntryManager.get_import_categories():
		var l := single.instance()
		var new_text: String = cat
		if Alias.has(cat, true):
			l.set_text(new_text, " -> " + Alias.category(cat).to_lower())
		else:
			l.set_text(new_text)
		categories.add_child(l)
	
	for sou in EntryManager.get_import_sources():
		var l := single.instance()
		var new_text: String = sou
		if Alias.has(sou, false):
			l.set_text(new_text, " -> " + Alias.source(sou).to_lower())
		else:
			l.set_text(new_text)
		sources.add_child(l)
	
	update_load()


func get_incl_categories() -> PoolStringArray:
	var cat: PoolStringArray = []
	for line in categories.get_children():
		if line.checked():
			cat.append(line.get_core())
	return cat


func get_incl_sources() -> PoolStringArray:
	var sou: PoolStringArray = []
	for line in sources.get_children():
		if line.checked():
			sou.append(line.get_core())
	return sou


func requires_both() -> bool:
	return $VBoxContainer/CheckBox.pressed


func update_load() -> void:
	load_button.get_popup().clear()
	for k in Profiles.get_keys():
		load_button.get_popup().add_item(k)


func _on_SaveAs_pressed():
	if not save_name.text:
		alert.show()
	else:
		Profiles.save_profile(save_name.text, get_incl_categories(),
				get_incl_sources(), requires_both())
