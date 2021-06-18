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

onready var score_items := $VBoxContainer.get_children()
# The one the Spindle points at
onready var center_item := $VBoxContainer/ScoreItem4

var scores: Array = [
	-15,
	-5,
	10,
	15,
	20,
	25,
	25,
	30,
	35,
	40,
	45,
	50,
]

func _ready() -> void:	
	scores.shuffle()
	scores.append(-25)
	scores.append(85)
	scores.append(-25)
	set_values()
	
	yield(get_tree(), "idle_frame")
	var center_y := rect_global_position.y + (rect_size.y / 2.0)
	(material as ShaderMaterial).set_shader_param("base_y", center_y)
	print(center_y)


func _process(delta: float) -> void:
	pass


func set_values() -> void:
	assert(score_items.size() <= scores.size())
	for i in score_items.size():
		score_items[i].value = scores[i]


func start() -> void:
	$Timer.start()


func stop() -> int:
	$Timer.stop()
	return center_item.value


func tick() -> void:
	var shift = scores.pop_back()
	scores.push_front(shift)
	set_values()


func _on_Timer_timeout() -> void:
	tick()
