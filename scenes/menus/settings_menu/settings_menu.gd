class_name SettingsMenu
extends CanvasLayer


signal back_pressed

@onready var music_button: VolumeButton = %MusicButton


func _on_fullscreen_button_pressed() -> void:
	DisplayUtility.toggle_fullscreen()


func _on_godot_license_button_pressed() -> void:
	OS.shell_open("https://godotengine.org/license/")


func _on_language_toggle_button_pressed() -> void:
	LangUtility.toggle_japanese()


func _on_visibility_changed() -> void:
	if visible:
		InputDeviceListener.focus_depending_on_device(music_button)


func _on_back_button_pressed() -> void:
	back_pressed.emit()
