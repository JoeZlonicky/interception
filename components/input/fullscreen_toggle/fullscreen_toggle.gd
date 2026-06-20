extends Node
## Toggles between windowed and fullscreen when input action is pressed


func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("fullscreen_toggle"):
		return
	
	DisplayUtility.toggle_fullscreen()
