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

# position data for moving each player
const MAIN_SIZE := Vector2(393.75, 62.5)
const OTHER_SIZE := Vector2(365, 50)
const MAIN_POSITION := Vector2(-395, -168)
const POS_2 := Vector2(-365, -102)
const POS_3 := Vector2(-365, -51)
const Sizes := PoolVector2Array([MAIN_SIZE, OTHER_SIZE, OTHER_SIZE])
const Positions := PoolVector2Array([MAIN_POSITION, POS_2, POS_3])
const TWEEN_TIME := 0.15

var current_player := 0
var solve_reward := 150
var _spindle_score := 0

onready var p1 := $PlayersArrange/Player
onready var p2 := $PlayersArrange/Player2
onready var p3 := $PlayersArrange/Player3
onready var solve_box := $ConfirmationDialog as ConfirmationDialog
onready var tween := $Tween as Tween


func get_players_array() -> Array:
	return $PlayersArrange.get_children()


func _ready() -> void:
	solve_box.get_cancel().connect("pressed", self, "_on_ConfirmationDialog_canceled")
	solve_box.get_close_button().hide()
	p1.is_ai = GlobalVars.player_ai & 1 << 0
	p2.is_ai = GlobalVars.player_ai & 1 << 1
	p3.is_ai = GlobalVars.player_ai & 1 << 2
	p1.set_name(GlobalVars.p1_name)
	p2.set_name(GlobalVars.p2_name)
	p3.set_name(GlobalVars.p3_name)
	
	for x in (randi() % NUM_PLAYER) + 1:
		advance_player()


func start() -> void:
	emit_signal("game_log", get_current_player().player_name + " go!")
	cache_scores()


func quick_score_update() -> void:
	get_current_player().add_to_score(_spindle_score)


func highest_score() -> int:
	var score := 0
	for p in get_players_array():
		score = int(max(score, p.get_all_score()))
	return score


func _score_gained(number: int, final: bool) -> void:
	emit_signal("game_log", str(number) + " points gained")
	if final:
		emit_signal("game_log", "You solved it!")
		emit_signal("pre_reset")
		advance_player()
	elif number and not get_current_player().is_ai:
		solve_box.show()
		solve_box.get_ok().grab_focus()
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


func get_current_player() -> Node:
	return $PlayersArrange.get_child(0)


func advance_player() -> void:
	$PlayersArrange.move_child(get_current_player(), NUM_PLAYER - 1)
	
	tween.remove_all()
	for i in NUM_PLAYER:
		var p := get_players_array()[i] as Control
		tween.interpolate_property(p, "rect_size", p.rect_size, Sizes[i], TWEEN_TIME + 0.02)
		tween.interpolate_property(p, "rect_position", p.rect_position, Positions[i], TWEEN_TIME)
	tween.start()


func get_final_results() -> Array:
	cache_scores()
	var result_arr := get_players_array()
	result_arr.sort_custom(PlayerSort.new(), "sort_by_score")
	var results := []
	for p in result_arr:
		var result_dict := {
			"name" : p.get_display_name(),
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


func _on_Player_game_log(text: String) -> void:
	emit_signal("game_log", text)


func _on_ConfirmationDialog_confirmed() -> void:
	emit_signal("init_solve")


func _on_ConfirmationDialog_canceled() -> void:
	pass_turn()


func _on_EntryDisplay_guess_checked(solved: bool) -> void:
	if solved:
		emit_signal("game_log",
				"Correct! " + str(solve_reward) + " points earned!")
		get_current_player().add_to_score(solve_reward)
		emit_signal("pre_reset")
		advance_player()
#		clear_label()
	else:
		emit_signal("game_log", "Incorrect")
		pass_turn()


func _on_Tween_tween_all_completed() -> void:
	get_current_player().take_turn()


func _on_EntryDisplay_text_ready() -> void:
	yield(get_tree().create_timer(0.1), "timeout") # ensures that spindle is active
	get_current_player().take_turn()


class PlayerSort:
	static func sort_by_score(a, b) -> bool:
		return a.total > b.total
