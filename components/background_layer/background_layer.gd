class_name BackgroundLayer
extends CanvasLayer


const CENTER := Vector2(0.5, 0.5)

var drop_progress: float = 0.0
var drop_tween: Tween
var ball: Ball

@onready var announcement_label: Label = %AnnouncementLabel
@onready var background: TextureRect = $Background
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _process(delta: float) -> void:
	var ball_pos_ratio := ball.global_position / ball.get_viewport_rect().size if ball else CENTER
	
	var current_bg_offset: Vector2 = background.get_instance_shader_parameter("offset")
	var target_bg_offset := Vector2(0.475, 0.475) + ball_pos_ratio * 0.05
	var new_bg_offset := current_bg_offset.move_toward(target_bg_offset, delta * 0.1)

	background.set_instance_shader_parameter("offset", new_bg_offset)
	background.set_instance_shader_parameter("progress", drop_progress)


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
	
	if from_level:
		drop_progress += from_level * 3
		drop_tween = create_tween()
		drop_tween.tween_property(self, "drop_progress", 0.0, 2.0).set_trans(Tween.TRANS_CUBIC)
	
		await drop_tween.finished
	
	announce_level(0)


func announce_level(level: int, delay_s: float = 0.0) -> void:
	if delay_s:
		await get_tree().create_timer(delay_s, false).timeout
	animation_player.stop()
	announcement_label.text = tr("LEVEL_PREFIX") + str(level + 1)
	animation_player.play("announce")
