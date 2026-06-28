class_name TweenUtility


static func fade_in(node: CanvasItem, duration_s: float = 0.5) -> Tween:
	var tween := node.create_tween()
	tween.tween_property(node, "modulate:a", 1.0, duration_s)
	return tween


static func fade_out(node: CanvasItem, duration_s: float = 0.5) -> Tween:
	var tween := node.create_tween()
	tween.tween_property(node, "modulate:a", 0.0, duration_s)
	return tween
