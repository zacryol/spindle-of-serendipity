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

extends "res://game/components/GameComponent.gd"

var score := 0
var total := 0
var player_name: String
var template := "%s: %d (%d)"
var template2 := "%s: %d (%d / %d)"
var is_ai := false

onready var info := $PanelContainer/CenterContainer/InfoLabel as Label

func set_label_text() -> void:
	if GlobalVars.win_by_score():
		info.text = template2 % [player_name, score, total, GlobalVars.win_score]
	else:
		info.text = template % [player_name, score, total]


func add_to_score(points: int) -> void:
	score += points
	set_label_text()
	
	if GlobalVars.win_by_score():
		if get_all_score() >= GlobalVars.win_score:
			($PanelContainer/CenterContainer as CanvasItem).modulate = Color.yellow


func set_name(new_name: String) -> void:
	player_name = new_name
	set_label_text()


func cache_score() -> void:
	total += score
	add_to_score(-score)


func get_all_score() -> int:
	return score + total


func spin_spindle() -> void:
	var action_event := InputEventAction.new()
	action_event.pressed = true
	action_event.action = "spindle"
	Input.parse_input_event(action_event)


func take_turn() -> void:
#	if not is_ai:
#		return
	spin_spindle()
	yield(get_tree().create_timer(1.0), "timeout")
	spin_spindle()
	# guess letter
	pass
