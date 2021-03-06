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

extends Node

const DEFAULT_CATEGORY := "Miscellaneous"
const DEFAULT_SOURCE := "N/A"

const ENTRIES_SAVE := "user://entries/"
const SETTINGS_SAVE := "user://settings.dat"
const ALIAS_SAVE := "user://alias.dat"
const PROFILE_SAVE := "user://profiles.dat"

# Settings constants and vars
enum {
	SOURCE_NEVER
	SOURCE_SOLVE
	SOURCE_ALWAYS
}

enum {
	RAND_NON
	RAND_CAT
	RAND_SOU
}

var settings: Dictionary = {
	"source" : SOURCE_SOLVE,
	"rand" : RAND_NON,
	"refresh" : 15,
}
# End of Settings

const PLAYER_NAME_MAX := 19

var p1_name := "Player 1"
var p2_name := "Player 2"
var p3_name := "Player 3"

var p1_name_default := "Player 1"
var p2_name_default := "Player 2"
var p3_name_default := "Player 3"

# Game Type, condition
var win_score := 1000
var rounds := 7
var win_by_score := false
var win_by_rounds := false

func win_by_score() -> bool:
	return win_by_score

func win_by_rounds() -> bool:
	return win_by_rounds

# End Type

func _ready():
	load_settings_from_file()
	randomize()
	OS.min_window_size = Vector2(1024, 576)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen


func save_settings_to_file():
	var f := File.new()
	var err := f.open(SETTINGS_SAVE, File.WRITE)
	if err:
		return
	f.store_var(settings)
	f.close()


func load_settings_from_file():
	var f := File.new()
	if f.file_exists(SETTINGS_SAVE):
		var err := f.open(SETTINGS_SAVE, File.READ)
		if err:
			return
		var d = f.get_var()
		if typeof(d) == TYPE_DICTIONARY:
			settings = d
		f.close()
