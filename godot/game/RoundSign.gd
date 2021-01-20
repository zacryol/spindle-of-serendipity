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

extends CanvasLayer

var message := "Round %s"
var suffix := " of %s"

onready var label: Label = $Main/PanelContainer/Label

func _ready():
	pass


func new_round(num: int) -> void:
	var show := message % str(num)
	if GlobalVars.win_by_rounds():
		if GlobalVars.rounds == num:
			show = "Final Round"
			label.modulate = Color(1, 0, 0, 1)
		else:
			show += suffix % str(GlobalVars.rounds)
	label.text = show
	$AnimationPlayer.play("In")
	$Timer.start()


func _on_EntryDisplay_text_ready():
	if $Timer.time_left:
		yield($Timer, "timeout")
	
	$AnimationPlayer.play("Out")
