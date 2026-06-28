class_name Boundary
extends StaticBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func spawn() -> void:
	animation_player.play("spawn")


func despawn() -> void:
	animation_player.play("despawn")
	await animation_player.animation_finished
	queue_free()


func flash() -> void:
	if not animation_player.is_playing():
		animation_player.play("flash")
