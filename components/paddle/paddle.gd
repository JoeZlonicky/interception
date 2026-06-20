class_name Paddle
extends CharacterBody2D

const MOVE_SPEED: float = 300

var input: float = 0.0
var target: Node2D = null


# If a target is set (i.e. AI paddle), follow it
# Otherwise rely on manual input
func _physics_process(delta: float) -> void:
	if target:
		_follow_target()
	else:
		_follow_input()
	
	move_and_collide(velocity * delta)


# Update velocity based on input
func _follow_input() -> void:
	input = clampf(input, -1.0, 1.0)
	velocity.y = input * MOVE_SPEED


# Follow current target
func _follow_target() -> void:
	if not target: return
	
	var diff := target.global_position.y - global_position.y
	var direction := clampf(diff, -1.0, 1.0)
	velocity.y = direction * MOVE_SPEED
