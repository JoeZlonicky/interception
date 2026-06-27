class_name DevMenu
extends CanvasLayer


@onready var dropdowns: DevOptions = %Dropdowns


func _ready() -> void:
	if !OS.is_debug_build():
		queue_free()
		return
	
	dropdowns.create_menu("Utility", UtilityDevMenuEntries.get_entries())


func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("dev_menu_toggle"):
		return
	
	visible = not visible
