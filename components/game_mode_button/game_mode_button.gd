class_name GameModeButton
extends Button


@export var game_mode_data: GameModeData

var high_score: int = -1

@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel
@onready var high_score_label: Label = %HighScoreLabel


func _ready() -> void:
	if not game_mode_data:
		return
	
	title_label.text = game_mode_data.title
	description_label.text = game_mode_data.description
	high_score_label.hide()


func _notification(what: int) -> void:
	if what != NOTIFICATION_TRANSLATION_CHANGED:
		return
	
	if not is_node_ready():
		await ready
	
	if high_score >= 0:
		update_high_score(high_score)


func update_high_score(score: int) -> void:
	if score < high_score:
		return
	
	high_score_label.text = tr("HIGH_SCORE_LABEL") + str(score + 1)
	high_score_label.show()
	high_score = score


func _process(delta: float) -> void:
	var target_scale := _get_target_scale()
	scale.x = move_toward(scale.x, target_scale, delta * 2.0)
	scale.y = move_toward(scale.y, target_scale, delta * 2.0)


func _get_target_scale() -> float:
	if has_focus(true):
		return 1.05
	
	match get_draw_mode():
		DrawMode.DRAW_HOVER:
			return 1.05
		DrawMode.DRAW_PRESSED:
			return 0.95
	
	return 1.0
