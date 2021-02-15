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
const MAIN_SIZE := Vector2(275 * 1.25, 50 * 1.25)
const OTHER_SIZE := Vector2(275, 50)
const MAIN_POSITION := Vector2(-345, -165)
const POS_2 := Vector2(-275, -100)
const POS_3 := Vector2(-275, -50)
const Sizes := PoolVector2Array([MAIN_SIZE, OTHER_SIZE, OTHER_SIZE])
const Positions := PoolVector2Array([MAIN_POSITION, POS_2, POS_3])
const TWEEN_TIME := 0.15

var current_player := 0
var solve_reward := 150

onready var p1 := $PlayersArrange/Player
onready var p2 := $PlayersArrange/Player2
onready var p3 := $PlayersArrange/Player3
onready var p_label: Label = $PanelContainer/VBoxContainer/PanelContainer/Label as Label
onready var solve_box := $ConfirmationDialog
onready var tween := $Tween as Tween

#var players_array: Array setget ,get_players_array

func get_players_array() -> Array:
	return $PlayersArrange.get_children()


func _ready():
	solve_box.get_cancel().connect("pressed", self, "_on_ConfirmationDialog_canceled")
	solve_box.get_close_button().hide()
	p1.set_name(GlobalVars.p1_name)
	p2.set_name(GlobalVars.p2_name)
	p3.set_name(GlobalVars.p3_name)
#	current_player = randi() % NUM_PLAYER
	
	set_label()


func start():
	emit_signal("game_log", get_current_player().player_name + " go!")
	cache_scores()
	set_label()


func highest_score() -> int:
	var score := 0
	for p in get_players_array():
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


func get_current_player() -> Node:
	return $PlayersArrange.get_child(0)
#	return get_players_array()[current_player]


func advance_player():
#	current_player = wrapi(current_player + 1, 0, NUM_PLAYER)
	$PlayersArrange.move_child(get_current_player(), NUM_PLAYER - 1)
	set_label()
	
	tween.remove_all()
	for i in NUM_PLAYER:
		var p := get_players_array()[i] as Control
		tween.interpolate_property(p, "rect_size", p.rect_size, Sizes[i], TWEEN_TIME)
		tween.interpolate_property(p, "rect_position", p.rect_position, Positions[i], TWEEN_TIME)
#	tween.interpolate_property($PlayersArrange.get_child(0), "rect_size", $PlayersArrange.get_child(0).rect_size, MAIN_SIZE, 0.1)
#	tween.interpolate_property($PlayersArrange.get_child(1), "rect_size", $PlayersArrange.get_child(1).rect_size, OTHER_SIZE, 0.1)
#	tween.interpolate_property($PlayersArrange.get_child(2), "rect_size", $PlayersArrange.get_child(2).rect_size, OTHER_SIZE, 0.1)
#	tween.interpolate_property($PlayersArrange.get_child(0), "rect_position", $PlayersArrange.get_child(0).rect_position, MAIN_POSITION, 0.1)
#	tween.interpolate_property($PlayersArrange.get_child(1), "rect_position", $PlayersArrange.get_child(1).rect_position, POS_2, 0.1)
#	tween.interpolate_property($PlayersArrange.get_child(2), "rect_position", $PlayersArrange.get_child(2).rect_position, POS_3, 0.1)
	tween.start()


func set_label():
	p_label.text = get_current_player().player_name + "'s turn!"


func clear_label():
	p_label.text = ""


func get_final_results() -> Array:
	cache_scores()
	var result_arr := get_players_array()
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
