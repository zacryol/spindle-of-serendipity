###############################################################################
# spindle of serendipity                                                      #
# Copyright (C) 2020-2021 zacryol (https://gitlab.com/zacryol)                #
#-----------------------------------------------------------------------------#
# This file is part of spindle of serendipity.                                #
#                                                                             #
# spindle of serendipity is free software: you can redistribute it and/or     #
# modify it under the terms of the GNU General Public License as published by #
# the Free Software Foundation, either version 3 of the License, or           #
# (at your option) any later version.                                         #
#                                                                             #
# spindle of serendipity is distributed in the hope that it will be useful,   #
# but WITHOUT ANY WARRANTY; without even the implied warranty of              #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               #
# GNU General Public License for more details.                                #
#                                                                             #
# You should have received a copy of the GNU General Public License           #
# along with spindle of serendipity.                                          #
# If not, see <http://www.gnu.org/licenses/>.                                 #
###############################################################################

extends Control

onready var p1_enter := $Controls/Top/PlayersConf/RowP1/Name as LineEdit
onready var p2_enter := $Controls/Top/PlayersConf/RowP2/Name as LineEdit
onready var p3_enter := $Controls/Top/PlayersConf/RowP3/Name as LineEdit
onready var p1_ai := $Controls/Top/PlayersConf/RowP1/IsAI as CheckBox
onready var p2_ai := $Controls/Top/PlayersConf/RowP2/IsAI as CheckBox
onready var p3_ai := $Controls/Top/PlayersConf/RowP3/IsAI as CheckBox
onready var selector := $Controls/OptionButton as OptionButton

onready var rounds_box := $Controls/Top/Vict/Rounds/SpinBox as SpinBox
onready var score_box := $Controls/Top/Vict/Score/SpinBox as SpinBox
onready var rounds_check := $Controls/Top/Vict/Rounds/CheckBox as CheckBox
onready var score_check := $Controls/Top/Vict/Score/CheckBox as CheckBox


func _ready() -> void:
	MusicManager.play_song_id("menu")
	selector.add_item(Profiles.RESERVED)
	for k in Profiles.get_keys():
		selector.add_item(k)
	
	rounds_box.value = GlobalVars.rounds
	score_box.value = GlobalVars.win_score
	rounds_check.pressed = GlobalVars.win_by_rounds()
	score_check.pressed = GlobalVars.win_by_score()
	rounds_box.editable = GlobalVars.win_by_rounds()
	score_box.editable = GlobalVars.win_by_score()
	
	GlobalVars.player_ai = 0b0000


func _on_Button_pressed() -> void:
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
	
	# Set player AI status
	if p1_ai.pressed:
		GlobalVars.player_ai |= 1 << 0
	if p2_ai.pressed:
		GlobalVars.player_ai |= 1 << 1
	if p3_ai.pressed:
		GlobalVars.player_ai |= 1 << 2
	
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


func _on_Rounds_value_changed(value: float) -> void:
	GlobalVars.rounds = int(value)


func _on_Score_value_changed(value: float) -> void:
	GlobalVars.win_score = int(value)


func _on_Rounds_toggled(button_pressed: bool) -> void:
	GlobalVars.win_by_rounds = button_pressed
	rounds_box.editable = button_pressed


func _on_Score_toggled(button_pressed: bool) -> void:
	GlobalVars.win_by_score = button_pressed
	score_box.editable = button_pressed


func _on_ReturnButton_pressed() -> void:
	get_tree().change_scene("res://game/menus/MainMenu.tscn")
