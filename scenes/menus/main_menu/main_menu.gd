class_name MainMenu
extends CanvasLayer

const GAME_MODE_BUTTON_SCENE := preload("uid://bv14mubvwpcat")

@onready var menu_container: VBoxContainer = $MenuContainer
@onready var settings_menu: SettingsMenu = $SettingsMenu
@onready var game_modes_container: HBoxContainer = $MenuContainer/GameModesContainer


func display_game_modes(modes: Array[GameModeData]) -> void:
	for mode_data in modes:
		var button := GAME_MODE_BUTTON_SCENE.instantiate() as GameModeButton
		button.game_mode_data = mode_data
		game_modes_container.add_child(button)
	_set_default_focus()


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
