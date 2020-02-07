extends Node

const DEFAULT_CATEGORY := "Miscellaneous"
const DEFAULT_SOURCE := "N/A"

const ENTRIES_SAVE := "user://entries/"
const SETTINGS_SAVE := "user://settings.json"

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
# End of Settings


func _ready():
	randomize()


func save_settings_to_file():
	var f = File.new()
	f.open(SETTINGS_SAVE, File.WRITE)
	var settings_dict := {
		"show_source" : show_source,
		"rand_mode" : rand_mode
	}
	f.store_string(to_json(settings_dict))
	f.close()

func load_settings_from_file():
	var f = File.new()
	if f.file_exists(SETTINGS_SAVE):
		f.open(SETTINGS_SAVE, File.READ)
	
