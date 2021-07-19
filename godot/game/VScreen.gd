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

onready var place_labels := [
	$Main/Place1/Label,
	$Main/Place2/Label,
	$Main/Place3/Label,
]
onready var new_button := $Main/HBoxContainer/NewButton as Button

func _ready():
	pass


func show() -> void:
	MusicManager.play_song_id("end")
	$Main.show()
	new_button.grab_focus()


# Array of dictionaries returned from PlayersPanel.get_final_results()
func set_results(res: Array):
	var disp: String = "%s : %s points"
	for i in place_labels.size():
			place_labels[i].text = disp % [res[i]["name"], res[i]["score"]]


func _on_NewButton_pressed():
	get_tree().change_scene("res://game/GameSetting.tscn")


func _on_QuitButton_pressed():
	get_tree().change_scene("res://game/menus/MainMenu.tscn")
