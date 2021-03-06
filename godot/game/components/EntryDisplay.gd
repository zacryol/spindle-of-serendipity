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

extends "res://game/components/GameComponent.gd"

signal letters_revealed(number, final)
signal one_letter(letter)
signal guess_checked(solved)
signal text_ready

enum {
	MODE_DISABLED,
	MODE_LETTER,
	MODE_SOLVE,
}
var current_mode := MODE_DISABLED
var entry_text: String
var source_text: String
var bool_mask: Dictionary
var source_hide := "??? (Hidden until solved)"

onready var hex := $PanelContainer/ScrollContainer/CenterContainer/HexContainer
onready var source_label := $SourceLabel as Label
onready var cat_label := $CategoryLabel as Label
onready var solve_ui: VBoxContainer = $PanelContainer/Control/SolveUI

func _ready():
	bool_mask.clear()
	for c in CharSet.CHAR_MAIN:
		bool_mask[c] = false


func _input(event):
	if event is InputEventKey:
		if event.is_pressed() and \
				not event.is_echo() and \
				event.scancode == KEY_BACKSPACE:
			hex.pop_solve()


func set_display(entry: Entry):
	entry_text = entry.get_entry_text().to_upper()
	source_text = entry.get_game_source()
	
	for k in bool_mask.keys():
		bool_mask[k] = false
	
	cat_label.text = entry.get_game_category()
	if GlobalVars.settings["source"] == GlobalVars.SOURCE_ALWAYS:
		source_label.text = source_text
	elif GlobalVars.settings["source"] == GlobalVars.SOURCE_NEVER:
		source_label.text = ""
	else:
		source_label.text = source_hide
	print_debug(entry_text)
	hex.text = entry_text


func is_solved() -> bool:
	return hex.verify()


func get_char_at(index: int) -> String:
	return entry_text.substr(index, 1)


func _on_letter_guessed(letter: String):
	if current_mode == MODE_LETTER:
		single_letter_guessed(letter)
	elif current_mode == MODE_SOLVE:
		add_solve(letter)


func single_letter_guessed(letter: String):
	var guess := letter.substr(0, 1)
	if not bool_mask.has(guess):
		return 
	if bool_mask[guess] == false:
		bool_mask[guess] = true
		
		current_mode = MODE_DISABLED
		emit_signal("one_letter", letter)
		
		var num: int = yield(hex.reveal_letter(guess), "completed")
		
		emit_signal("game_log", str(num) + " revealed")
		emit_signal("letters_revealed", num, is_solved())
	else:
		emit_signal("game_log", guess + " has already been guessed")
	if is_solved() && GlobalVars.settings["source"] == GlobalVars.SOURCE_SOLVE:
		source_label.text = source_text


func add_solve(letter: String):
	if bool_mask.has(letter) and not bool_mask[letter]:
		hex.add_solve(letter)


func init_solve():
	current_mode = MODE_SOLVE
	solve_ui.show()


func _on_Spindle_spun():
	current_mode = MODE_LETTER


func _on_SolveButton_pressed():
	var solved := is_solved()
	solve_ui.hide()
	emit_signal("guess_checked", solved)
	hex.clear_solve()
	current_mode = MODE_DISABLED
	if solved:
		hex.reveal_all()
		for k in bool_mask.keys():
			bool_mask[k] = true
		if GlobalVars.settings["source"] == GlobalVars.SOURCE_SOLVE:
			source_label.text = source_text


func _on_BSpace_pressed():
	hex.pop_solve()


func _on_HexContainer_setup():
	emit_signal("text_ready")
