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

const MAX_LOG_CHAR := 120

var round_num := 0

onready var entry_display := $GP/VB/Game/Arrange/EntryDisplay
onready var log_label := $GP/VB/Top/HB/Label as Label
onready var new_button := $GP/VB/Top/HB/NewG as Button
onready var spindle := $GP/VB/Game/Arrange/Spindle
onready var players := $GP/VB/Game/Arrange/PlayersPanel
onready var keyboard := $GP/VB/Game/Arrange/Keyboard
onready var victory := $VScreen
onready var round_sign := $RoundSign
onready var quit_confirm := $QuitConfirm/Main/ConfirmationDialog as ConfirmationDialog

var quit_focus_cache: Control

func _ready() -> void:
	MusicManager.play_game_music()
	EntryManager.reset_picked()
	start()
	quit_confirm.get_cancel().connect("pressed", self, "_on_QuitConfirm_exit")
	quit_confirm.get_close_button().hide()


func start() -> void:
	entry_display.set_display(EntryManager.get_random_entry())
	round_num += 1
	round_sign.new_round(round_num)
	log_label.text = ""
	players.start()
	new_button.hide()
	keyboard.enable()


func total_win() -> bool:
	if GlobalVars.win_by_score():
		if players.highest_score() >= GlobalVars.win_score:
			return true
	
	if GlobalVars.win_by_rounds():
		if round_num >= GlobalVars.rounds:
			return true
	
	return false


func _log(text: String = ""):
	if text == "":
		log_label.text = text
	else:
		var new_text := str(log_label.text) + text + " -- "
		while new_text.length() > MAX_LOG_CHAR:
			new_text = new_text.substr(1)
		log_label.text = new_text


func _on_NewG_pressed():
	if total_win():
		victory.show()
		victory.set_results(players.get_final_results())
	else:
		start()


func _pre_reset():
	new_button.show()
	new_button.grab_focus()


func _on_Quit_pressed():
	quit_focus_cache = get_focus_owner()
	$QuitConfirm/Main.show()
	quit_confirm.show()
	quit_confirm.get_cancel().grab_focus()


func _on_QuitConfirm_confirmed():
	get_tree().change_scene("res://game/menus/MainMenu.tscn")


func _on_QuitConfirm_exit():
	if quit_focus_cache:
		quit_focus_cache.grab_focus()
	$QuitConfirm/Main.hide()
