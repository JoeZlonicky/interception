class_name Ball
extends CharacterBody2D


signal paddle_hit(paddle: Paddle)

const HIT_PARTICLE_SCENE := preload("uid://be262xlxf8xgx")
const MOVE_SPEED: float = 450.0

@onready var hit_sfx: AudioStreamPlayer2D = %HitSFX
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _process(delta: float) -> void:
	sprite_2d.rotation += delta * 2.0


# Move using velocity and check for collisions
func _physics_process(delta: float) -> void:
	if not velocity:
		return
	
	var collision := move_and_collide(velocity * delta)
	if not collision:
		return
	
	var collision_normal := collision.get_normal()
	var collision_object := collision.get_collider()
	var collision_position := collision.get_position()
	_collide_with(collision_object, collision_normal, collision_position)


# Bounce on hitting something
func _collide_with(body: Object, normal: Vector2, pos: Vector2) -> void:
	if body is Paddle:
		body.flash()
		paddle_hit.emit(body)
	
	var hit_particle := HIT_PARTICLE_SCENE.instantiate() as GPUParticles2D
	GameUtility.spawn(hit_particle, pos)
	hit_particle.rotation = normal.angle()
	hit_particle.emitting = true
	hit_particle.finished.connect(hit_particle.queue_free)
	
	velocity = velocity.bounce(normal)
	animation_player.play("flash")
	hit_sfx.play()


# Useful for setting the initial direction of the ball
func set_direction(direction: Vector2) -> void:
	if not direction:
		velocity = Vector2.ZERO
		return
	
	velocity = direction.normalized() * MOVE_SPEED
