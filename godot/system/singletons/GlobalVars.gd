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
enum Type{
	FREE,
	ROUNDS,
	SCORE,
}

var game_type: int = Type.FREE
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
	
	var t := Timer.new()
	add_child(t)
	t.wait_time = 5
	t.connect("timeout", self, "_timer")
	t.start()
	randomize()
	
	OS.min_window_size = Vector2(1024, 576)


func _timer():
	randomize()


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
