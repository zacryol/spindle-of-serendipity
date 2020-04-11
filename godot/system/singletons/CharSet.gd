extends Node

# Base character set that the player guesses from
const CHAR_MAIN := PoolStringArray([
	"Q",
	"W",
	"E",
	"R",
	"T",
	"Y",
	"U",
	"I",
	"O",
	"P", # End of Row 1
	"A",
	"S",
	"D",
	"F",
	"G",
	"H",
	"J",
	"K",
	"L", # End of Row 2
	"Z",
	"X",
	"C",
	"V",
	"B",
	"N",
	"M",
])

# Extended charset
# Each key is treated as the value for comparison
# but is rendered as original when revealed
# Could add more, but font of choice doesn't seem to have those
const CHAR_EXTEND: Dictionary = {
	"À":"A",
	"Á":"A",
	"Â":"A",
	"Ã":"A",
	"Ä":"A",
	"Å":"A",
	"Æ":"A",
	"Ç":"C",
	"È":"E",
	"É":"E",
	"Ê":"E",
	"Ë":"E",
	"Ì":"I",
	"Í":"I",
	"Î":"I",
	"Ï":"I",
	"Ñ":"N",
	"Ò":"O",
	"Ó":"O",
	"Ô":"O",
	"Õ":"O",
	"Ö":"O",
	"Ø":"0",
	"Ù":"U",
	"Ú":"U",
	"Û":"U",
	"Ü":"U",
}

# Determine keyboard layout - row lengths
# Remaining letters will be arranged according to largest value
const LINE_BREAKS := PoolIntArray([
	10,
	9,
])

func get_row_length() -> int:
	var length := 0
	for i in LINE_BREAKS:
		length = max(i, length)
	return length


func has(c: String) -> bool:
	return c in CHAR_MAIN or \
			(CHAR_EXTEND.has(c) and\
			CHAR_EXTEND[c] in CHAR_MAIN)


func get_char(c: String) -> String:
	if c in CHAR_EXTEND.keys():
		if CHAR_EXTEND[c] in CHAR_MAIN:
			return CHAR_EXTEND[c]
		else:
			return c
	else:
		return c


func compare(c1: String, c2: String) -> bool:
	return get_char(c1) == get_char(c2)
