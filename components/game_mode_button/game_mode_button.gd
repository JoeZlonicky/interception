class_name GameModeButton
extends Button


@export var game_mode_data: GameModeData

@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel


func _ready() -> void:
	if not game_mode_data:
		return
	
	title_label.text = game_mode_data.title
	description_label.text = game_mode_data.description


func _process(delta: float) -> void:
	var target_scale := _get_target_scale()
	scale.x = move_toward(scale.x, target_scale, delta * 2.0)
	scale.y = move_toward(scale.y, target_scale, delta * 2.0)


func _get_target_scale() -> float:
	if has_focus(true):
		return 1.1
	
	match get_draw_mode():
		DrawMode.DRAW_HOVER:
			return 1.1
		DrawMode.DRAW_PRESSED:
			return 0.9
	
	return 1.0
