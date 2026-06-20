class_name Game
extends Node2D


const BALL_SCENE := preload("uid://dpieyslanfybp")

var ball: Ball = null
var left_score: int = 0
var right_score: int = 0

@onready var left_score_label: Label = %LeftScoreLabel
@onready var right_score_label: Label = %RightScoreLabel
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
	spawn_ball()


# Restart the game on either goal being entered
# Update the oppsite sides score
# The goals have a collision mask for just the ball
func _on_left_goal_body_entered(_body: Node2D) -> void:
	right_score += 1
	right_score_label.text = str(right_score)
	score_sfx.play()
	restart.call_deferred()


func _on_right_goal_body_entered(_body: Node2D) -> void:
	left_score += 1
	left_score_label.text = str(left_score)
	score_sfx.play()
	restart.call_deferred()
