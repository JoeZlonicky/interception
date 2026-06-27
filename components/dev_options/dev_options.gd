class_name DevOptions
extends HBoxContainer


@export_range(4, 64, 1) var font_size: int = 16
@export_range(16, 200) var menu_width: int = 64


func create_menu(title: String, options: Dictionary[String, Callable]) -> void:
	var dropdown_button := _create_dropdown_toggle(title)
	var dropdown := _create_dropdown(dropdown_button)
	
	for option in options:
		_add_to_dropdown(dropdown, option, options[option])


func _create_dropdown_toggle(title: String) -> Button:
	var button := Button.new()
	button.toggle_mode = true
	button.text = title
	button.custom_minimum_size = Vector2(menu_width, 0)
	button.add_theme_font_size_override("font_size", font_size)
	add_child(button)
	return button


func _create_dropdown(dropdown_button: Button) -> VBoxContainer:
	var dropdown := VBoxContainer.new()
	dropdown.add_theme_constant_override("separation", 0)
	dropdown_button.add_child(dropdown)
	dropdown_button.pressed.connect(_toggle_dropdown.bind(dropdown_button, dropdown))
	dropdown.hide()
	return dropdown


func _add_to_dropdown(dropdown: VBoxContainer, label: String, f: Callable) -> void:
	var option_button := Button.new()
	option_button.text = label
	option_button.custom_minimum_size = Vector2(menu_width, 0)
	option_button.add_theme_font_size_override("font_size", font_size)
	option_button.pressed.connect(f)
	dropdown.add_child(option_button)


func _toggle_dropdown(button: Button, dropdown: VBoxContainer) -> void:
	dropdown.visible = !dropdown.visible
	if not dropdown.visible:
		return
	
	dropdown.global_position.x = button.global_position.x
	dropdown.global_position.y = button.global_position.y + button.get_rect().size.y
