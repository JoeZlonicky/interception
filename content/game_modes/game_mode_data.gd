class_name GameModeData
extends Resource


@export var title: String
@export var description: String

@export var two_player: bool = false
@export_range(1.0, 1000.0) var paddle_speed: float = 300.0
@export_range(1.0, 1000.0) var base_ball_speed: float = 300.0
@export_range(0.0, 1000.0) var ball_speed_increase_per_level: float = 0.0


func calculate_ball_speed(level: int) -> float:
	return base_ball_speed + ball_speed_increase_per_level * level
