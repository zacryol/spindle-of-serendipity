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

signal pre_reset
signal turn_done
signal init_solve

const NUM_PLAYER := 3
var current_player := 0
var solve_reward := 150

onready var p1 := $Player
onready var p2 := $Player2
onready var p3 := $Player3
onready var players_array := [p1, p2, p3]
onready var p_label: Label = $PanelContainer/VBoxContainer/PanelContainer/Label
onready var solve_box := $ConfirmationDialog
onready var tween := $Tween as Tween

func _ready():
	solve_box.get_cancel().connect("pressed", self, "_on_ConfirmationDialog_canceled")
	solve_box.get_close_button().hide()
	p1.set_name(GlobalVars.p1_name)
	p2.set_name(GlobalVars.p2_name)
	p3.set_name(GlobalVars.p3_name)
	current_player = randi() % NUM_PLAYER
	
	set_label()


func start():
	emit_signal("game_log", get_current_player().player_name + " go!")
	cache_scores()
	set_label()


func highest_score() -> int:
	var score := 0
	for p in players_array:
		score = int(max(score, p.get_all_score()))
	return score


func _score_gained(number: int, final: bool):
	get_current_player().add_to_score(number)
	emit_signal("game_log", str(number) + " points gained")
	if final:
		emit_signal("game_log", "You solved it!")
		emit_signal("pre_reset")
		advance_player()
		clear_label()
	elif number:
		solve_box.show()
	else:
		pass_turn()


func pass_turn() -> void:
	advance_player()
	emit_signal("game_log", get_current_player().player_name + " spin!")
	emit_signal("turn_done")


func cache_scores() -> void:
	p1.cache_score()
	p2.cache_score()
	p3.cache_score()


func get_current_player():
	return players_array[current_player]


func advance_player():
	current_player = wrapi(current_player + 1, 0, NUM_PLAYER)
	set_label()


func set_label():
	p_label.text = get_current_player().player_name + "'s turn!"


func clear_label():
	p_label.text = ""


func get_final_results() -> Array:
	cache_scores()
	var result_arr := players_array.duplicate()
	result_arr.sort_custom(PlayerSort.new(), "sort_by_score")
	var results := []
	for p in result_arr:
		var result_dict := {
			"name" : p.player_name,
			"score" : p.total,
		}
		results.append(result_dict)
	return results


func get_scores_ordered() -> PoolIntArray:
	var scores := [
		p1.score,
		p2.score,
		p3.score,
	]
	scores.sort()
	scores.invert()
	return PoolIntArray(scores)


func _on_Player_game_log(text: String):
	emit_signal("game_log", text)


func _on_ConfirmationDialog_confirmed():
	emit_signal("init_solve")


func _on_ConfirmationDialog_canceled():
	pass_turn()


func _on_EntryDisplay_guess_checked(solved: bool):
	if solved:
		emit_signal("game_log",
				"Correct! " + str(solve_reward) + " points earned!")
		get_current_player().add_to_score(solve_reward)
		emit_signal("pre_reset")
		advance_player()
		clear_label()
	else:
		emit_signal("game_log", "Incorrect")
		pass_turn()


class PlayerSort:
	static func sort_by_score(a, b):
		return a.total > b.total
