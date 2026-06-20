class_name GameUtility


static func get_game() -> Game:
	var scene_tree := Engine.get_main_loop() as SceneTree
	var game := scene_tree.current_scene as Game
	assert(game, "Trying to get game at an invalid time")
	return game


# Adds a node to the world at the given position
static func spawn(node: Node2D, at: Vector2) -> void:
	var game := get_game()
	game.add_child(node)
	node.global_position = at
