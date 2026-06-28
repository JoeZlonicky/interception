class_name Launcher
extends Node2D
## Intended to be run as the first scene of the project


@export_category(ExportCategories.REQUIRED)
@export var _main_scene: PackedScene

@export_category(ExportCategories.CONFIG)

@export var _min_window_size: Vector2i
@export_color_no_alpha var _render_clear_color: Color = Color.BLACK
## Mute master audio bus when in debug mode
@export var _debug_mute_audio: bool = false

@export_category(ExportCategories.OPTIONAL)
## Launch with a different scene only when in debug mode
@export var _debug_main_scene: PackedScene
@export var _particles_to_load: Array[GPUParticles2D] = []

func _ready() -> void:
	assert(_main_scene, "No main scene set for launcher")
	_initial_config()
	if !OS.is_debug_build():
		await _compile_particles()
	_launch_start_scene()


func _initial_config() -> void:
	RenderingServer.set_default_clear_color(_render_clear_color)
	get_window().min_size = _min_window_size
	if OS.is_debug_build() and _debug_mute_audio:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)


func _compile_particles() -> void:
	if not _particles_to_load or not _particles_to_load.size():
		return
	
	for p in _particles_to_load:
		p.emitting = true
	
	for i in 3:
		await RenderingServer.frame_post_draw


func _launch_start_scene() -> void:
	if OS.is_debug_build() and _debug_main_scene:
		get_tree().change_scene_to_packed.call_deferred(_debug_main_scene)
	else:
		get_tree().change_scene_to_packed.call_deferred(_main_scene)
