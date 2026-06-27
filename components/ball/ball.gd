class_name Ball
extends CharacterBody2D


signal hit

const HIT_PARTICLE_SCENE := preload("uid://be262xlxf8xgx")
const HITS_TO_EXPLODE: int = 15

var speed: float = 0.0
var direction := Vector2.RIGHT

@onready var hit_sfx: AudioStreamPlayer2D = %HitSFX
@onready var sprite: Sprite2D = $BallSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var trail_particles: GPUParticles2D = $TrailParticles


func _process(delta: float) -> void:
	sprite.rotation += delta * 2.0


# Move using velocity and check for collisions
func _physics_process(delta: float) -> void:
	if not direction:
		return

	var collision := move_and_collide(direction * speed * delta)
	if not collision:
		return
	
	var collision_normal := collision.get_normal()
	var collision_object := collision.get_collider()
	var collision_position := collision.get_position()
	_collide_with(collision_object, collision_normal, collision_position)


# Bounce on hitting something
func _collide_with(body: Object, normal: Vector2, pos: Vector2) -> void:
	if body is Paddle or body is Boundary:
		body.flash()
	
	var hit_particle := HIT_PARTICLE_SCENE.instantiate() as GPUParticles2D
	GameUtility.spawn(hit_particle, pos)
	hit_particle.rotation = normal.angle()
	hit_particle.emitting = true
	hit_particle.finished.connect(hit_particle.queue_free)
	
	hit_sfx.play()
	hit.emit()
	
	animation_player.play("flash")
	if body is Paddle:
		direction = _get_paddle_bounce_direction(body, normal)
	else:
		direction = direction.bounce(normal)


func _get_paddle_bounce_direction(paddle: Paddle, normal: Vector2) -> Vector2:
	var d := normal.rotated(-PI / 4.0)
	var diff := global_position.y - paddle.global_position.y
	var ratio := remap(diff, -paddle.HEIGHT / 2.0, paddle.HEIGHT / 2.0, 0, 1)
	ratio = clamp(ratio, 0, 1)
	return d.rotated(ratio * PI / 2.0)


# Useful for setting the initial direction of the ball
func set_direction(new_direction: Vector2) -> void:
	if not new_direction:
		direction = Vector2.ZERO
		return
	
	direction = new_direction.normalized()


func set_speed(new_speed: float) -> void:
	speed = new_speed
