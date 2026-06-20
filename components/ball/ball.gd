class_name Ball
extends CharacterBody2D


const MOVE_SPEED: float = 550.0

@onready var hit_sfx: AudioStreamPlayer2D = %HitSFX


# Move using velocity and check for collisions
func _physics_process(delta: float) -> void:
	if not velocity:
		return
	
	var collision := move_and_collide(velocity * delta)
	if not collision:
		return
	
	var collision_normal := collision.get_normal()
	var collision_object := collision.get_collider()
	_collide_with(collision_object, collision_normal)


# Bounce on hitting something
# NOTE: this a minimal implementation of the ball bouncing
# Normally the game also modifies the ball's trajectory based on where it hits a paddle
func _collide_with(body: Object, normal: Vector2) -> void:
	if body is Paddle:
		# Maybe you would want to do more here?
		pass
	velocity = velocity.bounce(normal)
	hit_sfx.play()


# Useful for setting the initial direction of the ball
func set_direction(direction: Vector2) -> void:
	if not direction:
		velocity = Vector2.ZERO
		return
	
	velocity = direction.normalized() * MOVE_SPEED
