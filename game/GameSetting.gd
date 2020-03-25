extends Control

onready var p1_enter := $VBoxContainer/LineEdit
onready var p2_enter := $VBoxContainer/LineEdit2
onready var p3_enter := $VBoxContainer/LineEdit3
onready var selector: OptionButton = $VBoxContainer/OptionButton

func _ready() -> void:
	selector.add_item(Profiles.RESERVED)
	for k in Profiles.get_keys():
		selector.add_item(k)
	pass


func _on_Button_pressed():
	if p1_enter.text:
		GlobalVars.p1_name = p1_enter.text
	else:
		GlobalVars.p1_name = GlobalVars.p1_name_default
	if p2_enter.text:
		GlobalVars.p2_name = p2_enter.text
	else:
		GlobalVars.p2_name = GlobalVars.p2_name_default
	if p3_enter.text:
		GlobalVars.p3_name = p3_enter.text
	else:
		GlobalVars.p3_name = GlobalVars.p3_name_default
	
	if GlobalVars.p1_name.length() > GlobalVars.PLAYER_NAME_MAX:
		GlobalVars.p1_name = GlobalVars.p1_name.substr(0, GlobalVars.PLAYER_NAME_MAX)
	if GlobalVars.p2_name.length() > GlobalVars.PLAYER_NAME_MAX:
		GlobalVars.p2_name = GlobalVars.p2_name.substr(0, GlobalVars.PLAYER_NAME_MAX)
	if GlobalVars.p3_name.length() > GlobalVars.PLAYER_NAME_MAX:
		GlobalVars.p3_name = GlobalVars.p3_name.substr(0, GlobalVars.PLAYER_NAME_MAX)
	
#	print(EntryManager.is_profile_valid(
#			Profiles.profiles_dict[selector.get_item_text(
#			selector.get_selected_id())]))
	var pid: String = selector.get_item_text(selector.get_selected_id())
	
	if selector.get_selected_id() == 0:
		EntryManager.set_profile()
	else:
		EntryManager.set_profile(pid)
	
	if EntryManager.get_available_entries().empty():
		print("bad")
	else:
		get_tree().change_scene("res://game/GamePanel.tscn")
