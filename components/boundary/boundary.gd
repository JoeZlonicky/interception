class_name Boundary
extends StaticBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func flash() -> void:
	animation_player.play("flash")
