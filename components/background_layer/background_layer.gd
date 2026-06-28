class_name BackgroundLayer
extends CanvasLayer


const CENTER := Vector2(0.5, 0.5)

var passive_progress_enabled: bool = true
var passive_progress_stopping: bool = false
var drop_progress: float = 0.0
var drop_tween: Tween
var ball: Ball

var announcement_delay_timer: SceneTreeTimer

@onready var announcement_label: Label = %AnnouncementLabel
@onready var background: TextureRect = $Background
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _process(delta: float) -> void:
	if passive_progress_stopping:
		drop_progress = move_toward(drop_progress, ceilf(drop_progress), delta)
		if is_equal_approx(drop_progress, floorf(drop_progress)):
			passive_progress_stopping = false
			drop_progress = 0.0
	elif passive_progress_enabled:
		drop_progress += delta
	
	var ball_pos_ratio := ball.global_position / ball.get_viewport_rect().size if ball else CENTER
	
	var current_bg_offset: Vector2 = background.get_instance_shader_parameter("offset")
	var target_bg_offset := Vector2(0.475, 0.475) + ball_pos_ratio * 0.05
	var new_bg_offset := current_bg_offset.move_toward(target_bg_offset, delta * 0.1)

	background.set_instance_shader_parameter("offset", new_bg_offset)
	background.set_instance_shader_parameter("progress", drop_progress)


func stop_passive_progress() -> void:
	passive_progress_enabled = false
	passive_progress_stopping = true


func next_level(new_level: int) -> void:
	announcement_label.text = str(new_level)
	drop_progress = 0.0
	
	drop_tween = create_tween()
	drop_tween.tween_property(self, "drop_progress", 10.0, 4.0).set_trans(Tween.TRANS_EXPO)
	announce_level(new_level, 2.5)
	await drop_tween.finished


func restart(from_level: int) -> void:
	if drop_tween:
		drop_tween.kill()
	
	announce_game_over()
	
	if from_level:
		drop_progress += from_level * 3
		drop_tween = create_tween()
		drop_tween.tween_property(self, "drop_progress", 0.0, 2.0).set_trans(Tween.TRANS_CUBIC)
	
		await drop_tween.finished
	else:
		await get_tree().create_timer(2.0, false).timeout


func announce_game_over() -> void:
	announcement_delay_timer = null
	animation_player.stop()
	announcement_label.text = tr("GAME_OVER")
	animation_player.play("announce")


func announce_level(level: int, delay_s: float = 0.0) -> void:
	if delay_s:
		var new_timer := get_tree().create_timer(delay_s, false)
		announcement_delay_timer = new_timer
		await announcement_delay_timer.timeout
		if announcement_delay_timer != new_timer:
			return
	
	animation_player.stop()
	announcement_label.text = tr("LEVEL_PREFIX") + str(level + 1)
	animation_player.play("announce")
