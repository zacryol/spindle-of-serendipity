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

var aliases_cat: Dictionary
var aliases_sou: Dictionary

func _ready() -> void:
	load_from_file()


func has(import: String, is_cat: bool) -> bool:
	if is_cat:
		return aliases_cat.has(import)
	else:
		return aliases_sou.has(import)


func add_category(old: String, new: String) -> void:
	aliases_cat[old] = new
	save_to_file()


func add_source(old: String, new: String) -> void:
	aliases_sou[old] = new
	save_to_file()


func erase_cat(old: String) -> void:
	aliases_cat.erase(old)
	save_to_file()


func erase_sou(old: String) -> void:
	aliases_sou.erase(old)
	save_to_file()


func category(import: String) -> String:
	if aliases_cat.has(import):
		return aliases_cat[import]
	else:
		return import


func source(import: String) -> String:
	if aliases_sou.has(import):
		return aliases_sou[import]
	else:
		return import


func load_from_file() -> void:
	var f := File.new()
	if f.file_exists(GlobalVars.ALIAS_SAVE):
		var err := f.open(GlobalVars.ALIAS_SAVE, File.READ)
		if err:
			return
		var s = f.get_var()
		if typeof(s) == TYPE_DICTIONARY:
			if s.has("cat"):
				aliases_cat = s["cat"]
			if s.has("sou"):
				aliases_sou = s["sou"]
		f.close()


func save_to_file() -> void:
	var save_dict := {
		"cat" : aliases_cat,
		"sou" : aliases_sou,
	}
	var f := File.new()
	var err := f.open(GlobalVars.ALIAS_SAVE, File.WRITE)
	if err:
		return
	f.store_var(save_dict)
	f.close()
