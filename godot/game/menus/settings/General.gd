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

onready var source_options: OptionButton = $Scroll/List/RevealSource/OptionButton
onready var rand_options: OptionButton= $Scroll/List/RandMode/OptionButton
onready var refr_options: SpinBox = $Scroll/List/Refresh/SpinBox

func _ready():
	source_options.select(GlobalVars.settings["source"])
	rand_options.select(GlobalVars.settings["rand"])
	refr_options.value = GlobalVars.settings["refresh"]


func _on_source_option_selected(id):
	GlobalVars.settings["source"] = id


func _on_rand_option_selected(id):
	GlobalVars.settings["rand"] = id


func _on_Save_pressed():
	GlobalVars.save_settings_to_file()


func _on_Refresh_value_changed(value):
	GlobalVars.settings["refresh"] = value


func _on_CheckButton_toggled(button_pressed: bool) -> void:
	pass
