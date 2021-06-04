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

const RESERVED := "Default (All Entries)"
var profiles_dict: Dictionary


func _ready() -> void:
	load_from_file()


func save_profile(id: String,
		cat: PoolStringArray, sou: PoolStringArray, 
		arc: PoolStringArray, count: int) -> void:
	profiles_dict[id] = {
		'cat' : cat,
		'sou' : sou,
		'arc' : arc,
		'match_count' : count,
	}
	write_to_file()


func get_keys() -> PoolStringArray:
	return PoolStringArray(profiles_dict.keys())


func get_profile_data(id: String) -> Dictionary:
	if profiles_dict.has(id):
		return profiles_dict[id]
	else:
		return {}


func write_to_file() -> void:
	var f := File.new()
	var err := f.open(GlobalVars.PROFILE_SAVE, File.WRITE)
	if err:
		return
	f.store_var(profiles_dict)
	f.close()


func load_from_file() -> void:
	var f := File.new()
	if not f.file_exists(GlobalVars.PROFILE_SAVE):
		return
	var err = f.open(GlobalVars.PROFILE_SAVE, File.READ)
	if err:
		return
	var p = f.get_var()
	if not typeof(p) == TYPE_DICTIONARY:
		return
	
	profiles_dict = p
	f.close()


func clear(id: String) -> void:
	if profiles_dict.has(id):
		profiles_dict.erase(id)
		write_to_file()


func profile_has_entry(e: Entry, pid: String) -> bool:
	if not profiles_dict.has(pid):
		return true
	var p := profiles_dict[pid] as Dictionary
	var c := get_profile_match_count(e, p)
	assert(p.has('match_count'))
	return c >= p.match_count


func get_profile_match_count(e: Entry, p: Dictionary) -> int:
	var count = 0
	assert(p.has_all(['cat', 'sou', 'arc']))
	if e.get_import_category() in p['cat']:
		count += 1
	if e.get_import_source() in p['sou']:
		count += 1
	if e.archive in p['arc']:
		count += 1
	
	return count
