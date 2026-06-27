extends CanvasLayer

signal closed

@export_custom(PROPERTY_HINT_INPUT_NAME, "") var start_action: StringName


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(start_action) and visible:
		hide()
		get_viewport().set_input_as_handled()
		closed.emit()
