class_name PauseMenu
extends CanvasLayer



@onready var options: VBoxContainer = $Options
@onready var continue_button: Button = $Options/ContinueButton
@onready var settings_button: Button = $Options/SettingsButton
@onready var quit_button: Button = $Options/QuitButton

@onready var confirm_quit: VBoxContainer = $ConfirmQuit
@onready var confirm_button: Button = $ConfirmQuit/ConfirmButton

@onready var settings_menu: SettingsMenu = $SettingsMenu


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_toggle"):
		if visible:
			_close()
		else:
			get_tree().paused = true
			show()
		get_viewport().set_input_as_handled()
	
	elif visible and event.is_action_pressed("ui_cancel"):
		if settings_menu.visible:
			_on_settings_menu_back_pressed()
		elif confirm_quit.visible:
			_on_cancel_button_pressed()
		else:
			_close()


func _close() -> void:
	get_tree().paused = false
	options.show()
	settings_menu.hide()
	confirm_quit.hide()
	hide()


func _on_continue_button_pressed() -> void:
	_close()


func _on_settings_button_pressed() -> void:
	options.hide()
	settings_menu.show()


func _on_quit_button_pressed() -> void:
	options.hide()
	confirm_quit.show()
	confirm_button.grab_focus()


func _on_confirm_button_pressed() -> void:
	get_tree().quit()


func _on_cancel_button_pressed() -> void:
	options.show()
	confirm_quit.hide()
	quit_button.grab_focus()


func _on_visibility_changed() -> void:
	if visible:
		continue_button.grab_focus()


func _on_settings_menu_back_pressed() -> void:
	settings_menu.hide()
	options.show()
	settings_button.grab_focus()
