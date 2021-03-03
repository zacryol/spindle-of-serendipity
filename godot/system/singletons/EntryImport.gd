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

func _ready() -> void:
	grab_saved_files()


func reimport(which: String = "") -> void:
	EntryManager.clear(which)
	if not which:
		grab_saved_files()
	else:
		import_entries_from_file(GlobalVars.ENTRIES_SAVE + which + ".json")


func import_entries_from_file(path: String) -> void:
	var f := File.new()
	var a := path.get_file()
	var err := f.open(path, File.READ)
	if err:
		return
	while not f.eof_reached():
		var line := f.get_line()
		var v := validate_json(line)
		if v:
			if line:
				print("ERROR: Entry \"" + line + "\" in file " + a + " is invalid")
			continue
		
		var j = parse_json(line)
		if typeof(j) == TYPE_ARRAY:
			var data := PoolStringArray(j)
			EntryManager.add_entry(a.get_basename(), data)
		
	f.close()


func grab_saved_files() -> void:
	var path := GlobalVars.ENTRIES_SAVE
	var d := Directory.new()
	if d.dir_exists(path) == false:
		d.make_dir_recursive(path)
	var err := d.open(path)
	if err:
		return
	d.list_dir_begin(true, true)
	while true:
		var f := d.get_next()
		if f == "":
			break
		import_entries_from_file(path + f)
