extends Node


func parse(input: String) -> PoolStringArray:
	var lines: PoolStringArray
	for s in input.split(" "):
		lines.append(s)
	return lines
