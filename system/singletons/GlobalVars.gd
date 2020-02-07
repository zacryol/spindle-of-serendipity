extends Node

const DEFAULT_CATEGORY := "Miscellaneous"
const DEFAULT_SOURCE := "N/A"

const ENTRIES_SAVE := "user://entries/"
const SETTINGS_SAVE := "user://settings/general"

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
