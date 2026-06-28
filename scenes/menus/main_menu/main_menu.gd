class_name MainMenu
extends CanvasLayer

signal game_mode_selected(mode_data: GameModeData)

const GAME_MODE_BUTTON_SCENE := preload("uid://bv14mubvwpcat")

var fade_out_tween: Tween
var mode_to_button_map: Dictionary[GameModeData, GameModeButton] = {}

@onready var menu_container: VBoxContainer = $MenuContainer
@onready var settings_menu: SettingsMenu = $SettingsMenu
@onready var game_modes_container: HBoxContainer = $MenuContainer/GameModesContainer
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	if OS.get_name() == "Web":
		quit_button.hide()


func display_game_modes(modes: Array[GameModeData]) -> void:
	for mode_data in modes:
		if mode_to_button_map.has(mode_data):
			continue
		
		var button := GAME_MODE_BUTTON_SCENE.instantiate() as GameModeButton
		button.game_mode_data = mode_data
		button.pressed.connect(_on_game_mode_button_selected.bind(mode_data))
		mode_to_button_map[mode_data] = button
		game_modes_container.add_child(button)


func update_high_score(mode: GameModeData, score: int) -> void:
	var button := mode_to_button_map.get(mode) as GameModeButton
	if not button:
		return
	
	button.update_high_score(score)


func fade_out() -> void:
	fade_out_tween = TweenUtility.fade_out(menu_container)
	await fade_out_tween.finished
	hide()
	fade_out_tween = null


func fade_in() -> void:
	show()
	menu_container.modulate.a = 0.0
	
	var fade_tween := TweenUtility.fade_in(menu_container)
	
	await get_tree().process_frame
	_set_default_focus()
	await fade_tween.finished


func _on_game_mode_button_selected(mode_data: GameModeData) -> void:
	if fade_out_tween:
		return
	game_mode_selected.emit(mode_data)


func _on_language_toggle_button_pressed() -> void:
	LangUtility.toggle_japanese()


func _on_settings_button_pressed() -> void:
	menu_container.hide()
	settings_menu.show()


func _on_settings_menu_back_pressed() -> void:
	menu_container.show()
	settings_menu.hide()
	_set_default_focus()


func _set_default_focus() -> void:
	if game_modes_container.get_child_count() == 0:
		return
	
	var first_mode := game_modes_container.get_child(0) as GameModeButton
	InputDeviceListener.focus_depending_on_device(first_mode)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
