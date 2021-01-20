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

class_name Entry
extends Reference

var archive: String = ""
var text: String
var category: String = GlobalVars.DEFAULT_CATEGORY
var source: String = GlobalVars.DEFAULT_SOURCE

var picked := false

func _init(file: String, 
		new_text: String,
		new_category := "",
		new_source := ""):
	archive = file
	text = new_text
	if new_category:
		category = new_category
	if new_source:
		source = new_source


func get_entry_text() -> String:
	return text


func get_import_category() -> String:
	return category


func get_import_source() -> String:
	return source


func get_game_category() -> String:
	return Alias.category(category)


func get_game_source() -> String:
	return Alias.source(source)


func _to_string() -> String:
	return "Text: " + text + ", Category: " + category + ", Source: " + source
