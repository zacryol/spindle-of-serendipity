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

onready var source_options : = $Scroll/List/RevealSource/OptionButton as OptionButton
onready var rand_options := $Scroll/List/RandMode/OptionButton as OptionButton
onready var refr_options := $Scroll/List/Refresh/SpinBox as SpinBox
onready var crt_option := $Scroll/List/CRTShader/CheckButton as CheckButton

onready var mus_vol := $Scroll/List/MusicVolume/HSlider as HSlider
onready var sfx_vol := $Scroll/List/SFXVolume/HSlider as HSlider
onready var tick_audio := $SliderTickPlayer as AudioStreamPlayer

func _ready() -> void:
	source_options.select(GlobalVars.settings["source"])
	rand_options.select(GlobalVars.settings["rand"])
	refr_options.value = GlobalVars.settings["refresh"]
	crt_option.pressed = GlobalVars.settings.crt_on
	
	mus_vol.value = GlobalVars.settings.music_vol
	sfx_vol.value = GlobalVars.settings.sfx_vol


func _on_source_option_selected(id: int) -> void:
	GlobalVars.settings["source"] = id


func _on_rand_option_selected(id: int) -> void:
	GlobalVars.settings["rand"] = id


func _on_Save_pressed() -> void:
	GlobalVars.save_settings_to_file()


func _on_Refresh_value_changed(value: int) -> void:
	GlobalVars.settings["refresh"] = value


func _on_CheckButton_toggled(button_pressed: bool) -> void:
	GlobalVars.settings.crt_on = button_pressed
	FxManager.toggle_crt(button_pressed)


func _on_sfx_value_changed(value: float) -> void:
	GlobalVars.set_volume(value, "sfx")
	tick_audio.play()


func _on_music_value_changed(value: float) -> void:
	GlobalVars.set_volume(value, "music")
	tick_audio.play()
