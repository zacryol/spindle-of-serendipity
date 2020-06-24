extends Control

onready var p1_enter: LineEdit = $Controls/Top/NameSetting/LineEdit
onready var p2_enter: LineEdit = $Controls/Top/NameSetting/LineEdit2
onready var p3_enter: LineEdit = $Controls/Top/NameSetting/LineEdit3
onready var selector: OptionButton = $Controls/OptionButton

onready var type_selector: OptionButton = $Controls/Top/Vict/Type
onready var rounds_box: SpinBox = $Controls/Top/Vict/Rounds/SpinBox
onready var score_box: SpinBox = $Controls/Top/Vict/Score/SpinBox

func _ready() -> void:
	selector.add_item(Profiles.RESERVED)
	for k in Profiles.get_keys():
		selector.add_item(k)
	
	type_selector.selected = GlobalVars.game_type
	rounds_box.value = GlobalVars.rounds
	score_box.value = GlobalVars.win_score
	rounds_box.editable = GlobalVars.win_by_rounds()
	score_box.editable = GlobalVars.win_by_score()


func _on_Button_pressed():
	# Set Player names
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
	
	# Limit name length
	if GlobalVars.p1_name.length() > GlobalVars.PLAYER_NAME_MAX:
		GlobalVars.p1_name = GlobalVars.p1_name.substr(0, GlobalVars.PLAYER_NAME_MAX)
	if GlobalVars.p2_name.length() > GlobalVars.PLAYER_NAME_MAX:
		GlobalVars.p2_name = GlobalVars.p2_name.substr(0, GlobalVars.PLAYER_NAME_MAX)
	if GlobalVars.p3_name.length() > GlobalVars.PLAYER_NAME_MAX:
		GlobalVars.p3_name = GlobalVars.p3_name.substr(0, GlobalVars.PLAYER_NAME_MAX)
	
	# Set win conditions
	
	# Check Profile
	var pid: String = selector.get_item_text(selector.get_selected_id())
	
	if selector.get_selected_id() == 0:
		EntryManager.set_profile()
	else:
		EntryManager.set_profile(pid)
	
	if EntryManager.get_available_entries().empty():
		$AcceptDialog.show()
	else:
		get_tree().change_scene("res://game/GamePanel.tscn")


func _on_Type_item_selected(id: int):
	rounds_box.editable = id == 1
	score_box.editable = id == 2
	GlobalVars.game_type = id
	GlobalVars.rounds = rounds_box.value
	GlobalVars.win_score = score_box.value


func _on_Rounds_value_changed(value: float):
	GlobalVars.rounds = floor(value)


func _on_Score_value_changed(value: float):
	GlobalVars.win_score = floor(value)
