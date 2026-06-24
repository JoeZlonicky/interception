class_name Game
extends Node2D


const BALL_SCENE := preload("uid://dpieyslanfybp")

var ball: Ball = null
var level: int = 0
var drop_progress: float = 0.0
var drop_tween: Tween

@onready var announcement_label: Label = %AnnouncementLabel
@onready var ball_spawn_position: Marker2D = %BallSpawnPosition
@onready var left_paddle: Paddle = %LeftPaddle
@onready var right_paddle: Paddle = %RightPaddle
@onready var score_sfx: AudioStreamPlayer = %ScoreSFX
@onready var background: TextureRect = $BackgroundLayer/Background
@onready var drop_timer: Timer = $DropTimer


# Game starts with a new ball spawning
func _ready() -> void:
	spawn_ball()


# Control the left paddle with input
func _process(delta: float) -> void:
	left_paddle.input = Input.get_axis("player_1_move_up", "player_1_move_down")
	
	var current_bg_offset: Vector2 = background.get_instance_shader_parameter("offset")
	
	if ball:
		var ball_pos_ratio := ball.global_position / get_viewport_rect().size
		
		var target_bg_offset := Vector2(0.475, 0.475) + ball_pos_ratio * 0.05
		var new_bg_offset := current_bg_offset.move_toward(target_bg_offset, delta * 0.1)
		
		var target_label_offset := Vector2.ONE * -5.0 + ball_pos_ratio * 10.0
		var new_label_offset := announcement_label.offset_transform_position.move_toward(target_label_offset, delta * 20.0)
		announcement_label.offset_transform_position = new_label_offset
		background.set_instance_shader_parameter("offset", new_bg_offset)
	
	background.set_instance_shader_parameter("progress", drop_progress)

	#right_paddle.input = Input.get_axis("player_2_move_up", "player_2_move_down")


# Spawn a new ball in a random angled direction
func spawn_ball() -> void:
	if ball:
		ball.queue_free()
	
	ball = BALL_SCENE.instantiate()
	ball.global_position = ball_spawn_position.global_position
	add_child(ball)
	
	# Randomly choose NE, NW, SW, or SE direction
	var starting_angle: float = [1, 3, 5, 7].pick_random() * PI / 4.0
	var starting_direction := Vector2.from_angle(starting_angle)
	ball.set_direction(starting_direction)
	
	# Update what the AI paddles is following
	right_paddle.target = ball


func next_level() -> void:
	level += 1
	announcement_label.text = str(level)
	drop_progress = 0.0
	
	drop_tween = create_tween()
	drop_tween.tween_property(self, "drop_progress", 3.0, 2.0).set_trans(Tween.TRANS_EXPO)


# Restart game by spawning a new ball
# Note that paddles are *not* reset
func restart() -> void:
	if drop_tween:
		drop_tween.kill()
	drop_timer.stop()
	score_sfx.play()
	
	if level:
		drop_progress += level
		drop_tween = create_tween()
		drop_tween.tween_property(self, "drop_progress", 0.0, 2.0).set_trans(Tween.TRANS_CUBIC)
	
		await drop_tween.finished
	
	drop_timer.start()
	level = 0
	announcement_label.text = str(level)
	spawn_ball()


func _ball_out_of_bounds() -> void:
	restart()


# Restart the game on either bounds being entered
func _on_left_bounds_body_entered(_body: Node2D) -> void:
	_ball_out_of_bounds.call_deferred()


func _on_right_bounds_body_entered(_body: Node2D) -> void:
	_ball_out_of_bounds.call_deferred()


func _on_drop_timer_timeout() -> void:
	next_level()
