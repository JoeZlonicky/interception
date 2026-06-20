class_name Game
extends Node2D


const BALL_SCENE := preload("uid://dpieyslanfybp")

var ball: Ball = null
var level: int = 0

@onready var level_label: Label = %LevelLabel
@onready var ball_spawn_position: Marker2D = %BallSpawnPosition
@onready var left_paddle: Paddle = %LeftPaddle
@onready var right_paddle: Paddle = %RightPaddle
@onready var score_sfx: AudioStreamPlayer = %ScoreSFX


# Game starts with a new ball spawning
func _ready() -> void:
	spawn_ball()


# Control the left paddle with input
func _process(_delta: float) -> void:
	left_paddle.input = Input.get_axis("move_up", "move_down")


# Spawn a new ball in a random angled direction
func spawn_ball() -> void:
	ball = BALL_SCENE.instantiate()
	ball.global_position = ball_spawn_position.global_position
	ball.paddle_hit.connect(_on_ball_paddle_hit)
	add_child(ball)
	
	# Randomly choose NE, NW, SW, or SE direction
	var starting_angle: float = [1, 3, 5, 7].pick_random() * PI / 4.0
	var starting_direction := Vector2.from_angle(starting_angle)
	ball.set_direction(starting_direction)
	
	# Update what the AI paddles is following
	right_paddle.target = ball


# Restart game by spawning a new ball
# Note that paddles are *not* reset
func restart() -> void:
	if ball:
		ball.queue_free()
	score_sfx.play()
	spawn_ball()
	level = 0
	level_label.text = str(level)


func _next_level() -> void:
	level += 1
	level_label.text = str(level)


func _on_ball_paddle_hit(_paddle: Paddle) -> void:
	_next_level()


func _ball_out_of_bounds() -> void:
	restart()
	

# Restart the game on either bounds being entered
func _on_left_bounds_body_entered(_body: Node2D) -> void:
	_ball_out_of_bounds.call_deferred()


func _on_right_bounds_body_entered(_body: Node2D) -> void:
	_ball_out_of_bounds.call_deferred()
