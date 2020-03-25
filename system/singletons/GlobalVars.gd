extends Node

const DEFAULT_CATEGORY := "Miscellaneous"
const DEFAULT_SOURCE := "N/A"

const ENTRIES_SAVE := "user://entries/"
const SETTINGS_SAVE := "user://settings.json"
const ALIAS_SAVE := "user://alias.dat"
const PROFILE_SAVE := "user://profiles.dat"

# Settings constants and vars
enum {
	SOURCE_NEVER
	SOURCE_SOLVE
	SOURCE_ALWAYS
}
var show_source := SOURCE_SOLVE

enum {
	RAND_NON
	RAND_CAT
	RAND_SOU
}
var rand_mode := RAND_NON

var refresh_entries_at := 15
# End of Settings

const PLAYER_NAME_MAX := 19

var p1_name := "Player 1"
var p2_name := "Player 2"
var p3_name := "Player 3"

var p1_name_default := "Player 1"
var p2_name_default := "Player 2"
var p3_name_default := "Player 3"

func _ready():
	load_settings_from_file()
	
	var t := Timer.new()
	add_child(t)
	t.wait_time = 5
	t.connect("timeout", self, "_timer")
	t.start()
	randomize()


func _timer():
	randomize()


func save_settings_to_file():
	var f := File.new()
	var err := f.open(SETTINGS_SAVE, File.WRITE)
	if err:
		return
	var settings_dict := {
		"show_source" : show_source,
		"rand_mode" : rand_mode,
		"refresh" : refresh_entries_at,
	}
	f.store_string(to_json(settings_dict))
	f.close()


func load_settings_from_file():
	var f := File.new()
	if f.file_exists(SETTINGS_SAVE):
		var err := f.open(SETTINGS_SAVE, File.READ)
		if err:
			return
		var settings_string := f.get_as_text()
		var v := validate_json(settings_string)
		if not v:
			var settings_dict = parse_json(settings_string)
			if typeof(settings_dict) == TYPE_DICTIONARY:
				if settings_dict.has("show_source"):
					show_source = settings_dict["show_source"]
				if settings_dict.has("rand_mode"):
					rand_mode = settings_dict["rand_mode"]
				if settings_dict.has("refresh"):
					refresh_entries_at = settings_dict["refresh"]
