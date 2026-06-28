class_name Game
extends Node2D


const BOUNDARY_SCENE := preload("uid://cqs024kaj0suc")
const PADDLE_SCENE := preload("uid://dfq6d3x5qit4i")
const BALL_SCENE := preload("uid://dpieyslanfybp")

@export var all_game_modes: Array[GameModeData] = []
@export var game_mode: GameModeData

var left_paddle: Paddle
var right_paddle: Paddle
var right_boundary: Boundary

var ball: Ball = null
var level: int = 0

@onready var main_menu: MainMenu = $MainMenu
@onready var background_layer: BackgroundLayer = $BackgroundLayer
@onready var ball_spawn_position: Marker2D = %BallSpawnPosition

@onready var right_boundary_spawn_position: Marker2D = $RightBoundarySpawnPosition
@onready var left_paddle_spawn_position: Marker2D = $LeftPaddleSpawnPosition
@onready var right_paddle_spawn_position: Marker2D = $RightPaddleSpawnPosition

@onready var game_over_sfx: AudioStreamPlayer = %GameOverSFX
@onready var drop_timer: Timer = $DropTimer
@onready var left_score_particles: GPUParticles2D = $LeftScoreParticles
@onready var right_score_particles: GPUParticles2D = $RightScoreParticles


func _ready() -> void:
	main_menu.fade_in()
	main_menu.display_game_modes(all_game_modes)


func _process(_delta: float) -> void:
	if left_paddle:
		left_paddle.input = Input.get_axis("player_1_move_up", "player_1_move_down")
	if right_paddle:
		right_paddle.input = Input.get_axis("player_2_move_up", "player_2_move_down")


func spawn_paddles_and_walls() -> void:
	left_paddle = PADDLE_SCENE.instantiate() as Paddle
	left_paddle_spawn_position.add_sibling(left_paddle)
	left_paddle.global_position = left_paddle_spawn_position.global_position
	
	if game_mode.two_player:
		right_paddle = PADDLE_SCENE.instantiate() as Paddle
		right_paddle_spawn_position.add_sibling(right_paddle)
		right_paddle.global_position = right_paddle_spawn_position.global_position
		right_paddle.rotation_degrees = 180
	else:
		right_boundary = BOUNDARY_SCENE.instantiate() as Boundary
		right_paddle_spawn_position.add_sibling(right_boundary)
		right_boundary.global_position = right_boundary_spawn_position.global_position
		right_boundary.rotation_degrees = 90
		right_boundary.spawn()


# Spawn a new ball in a random angled direction
func spawn_ball() -> void:
	if ball:
		ball.queue_free()
	
	ball = BALL_SCENE.instantiate()
	ball.global_position = ball_spawn_position.global_position
	add_child(ball)
	background_layer.ball = ball
	
	# Randomly choose NE, NW, SW, or SE direction
	var starting_angle: float = [1, 3, 5, 7].pick_random() * PI / 4.0
	var starting_direction := Vector2.from_angle(starting_angle)
	ball.set_direction(starting_direction)
	_update_ball_speed()


func next_level() -> void:
	level += 1
	main_menu.update_high_score(game_mode, level)
	_update_ball_speed()
	background_layer.next_level(level)


func restart() -> void:
	ball.queue_free()
	left_paddle.despawn()
	if right_paddle:
		right_paddle.despawn()
	if right_boundary:
		right_boundary.despawn()
	
	background_layer.ball = null
	drop_timer.stop()
	game_over_sfx.play()
	
	await background_layer.restart(level)
	
	background_layer.passive_progress_enabled = true
	main_menu.fade_in()
	
	ball = null
	left_paddle = null
	right_paddle = null
	right_boundary = null
	level = 0


func _update_ball_speed() -> void:
	var ball_speed := game_mode.calculate_ball_speed(level)
	if ball:
		ball.set_speed(ball_speed)


func _ball_out_of_bounds() -> void:
	restart()


func _on_left_bounds_body_entered(_body: Node2D) -> void:
	_ball_out_of_bounds.call_deferred()
	left_score_particles.emitting = true


func _on_right_bounds_body_entered(_body: Node2D) -> void:
	_ball_out_of_bounds.call_deferred()
	right_score_particles.emitting = true


func _on_drop_timer_timeout() -> void:
	next_level()


func _on_main_menu_game_mode_selected(mode_data: GameModeData) -> void:
	background_layer.stop_passive_progress()
	main_menu.fade_out()
	game_mode = mode_data
	
	spawn_paddles_and_walls()
	background_layer.announce_level(level)
	
	await get_tree().create_timer(2.0, false).timeout
	
	main_menu.update_high_score(game_mode, level)
	spawn_ball()
	drop_timer.start()
