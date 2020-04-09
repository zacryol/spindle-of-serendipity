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
