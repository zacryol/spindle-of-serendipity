extends MarginContainer


func _on_HexContainer_sort_children():
	var p := get_parent()
	if p is ScrollContainer:
		var rect: Vector2 = p.rect_size
		var hex_min: Vector2 = $HexContainer.rect_min_size
		set("custom_constants/margin_top", max(0, rect.y - hex_min.y) / 2)
		set("custom_constants/margin_left", max(0, rect.x - hex_min.x) / 2)
