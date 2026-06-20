class_name CameraUtility


static func set_limits_from_rect(camera: Camera2D, rect: Rect2) -> void:
	camera.limit_left = floori(rect.position.x)
	camera.limit_right = ceil(rect.position.x + rect.size.x)
	camera.limit_top = floori(rect.position.y)
	camera.limit_bottom = ceili(rect.position.y + rect.size.y)
