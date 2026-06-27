class_name Game
extends Node2D


const BALL_SCENE := preload("uid://dpieyslanfybp")

@export var game_mode: GameModeData

var ball: Ball = null
var level: int = 0

@onready var background_layer: BackgroundLayer = $BackgroundLayer
@onready var ball_spawn_position: Marker2D = %BallSpawnPosition
@onready var left_paddle: Paddle = %LeftPaddle
@onready var right_paddle: Paddle = %RightPaddle
@onready var score_sfx: AudioStreamPlayer = %ScoreSFX
@onready var drop_timer: Timer = $DropTimer


# Game starts with a new ball spawning
func _ready() -> void:
	spawn_ball()


# Control the left paddle with input
func _process(_delta: float) -> void:
	left_paddle.input = Input.get_axis("player_1_move_up", "player_1_move_down")
	#right_paddle.input = Input.get_axis("player_2_move_up", "player_2_move_down")


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
	
	# Update what the AI paddles is following
	right_paddle.target = ball


func next_level() -> void:
	level += 1
	_update_ball_speed()
	background_layer.next_level(level)


# Restart game by spawning a new ball
# Note that paddles are *not* reset
func restart() -> void:
	ball.queue_free()
	background_layer.ball = null
	
	drop_timer.stop()
	score_sfx.play()
	
	await background_layer.restart(level)
	
	drop_timer.start()
	level = 0
	spawn_ball()


func _update_ball_speed() -> void:
	var ball_speed := game_mode.calculate_ball_speed(level)
	if ball:
		ball.set_speed(ball_speed)


func _ball_out_of_bounds() -> void:
	restart()


# Restart the game on either bounds being entered
func _on_left_bounds_body_entered(_body: Node2D) -> void:
	_ball_out_of_bounds.call_deferred()


func _on_right_bounds_body_entered(_body: Node2D) -> void:
	_ball_out_of_bounds.call_deferred()


func _on_drop_timer_timeout() -> void:
	next_level()
