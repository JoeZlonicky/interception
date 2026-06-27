class_name VolumeButton
extends Button


# Number of presses to go from 100 to 0
@export_range(1, 20, 1) var n_increments = 5

@export var audio_bus: String = "Master"


var _volume_level: float = 100.0

@onready var _label_text: String = text


func _ready() -> void:
	var bus_idx := AudioServer.get_bus_index(audio_bus)
	assert(bus_idx > -1, ConfigurationWarnings.invalid_property(self, "audio_bus"))
	
	_update_text()


func _notification(what: int) -> void:
	if what != NOTIFICATION_TRANSLATION_CHANGED:
		return
	
	if not is_node_ready():
			await ready
	
	_update_text()


func _update_text() -> void:
	text = tr(_label_text) + str(roundi(_volume_level)) + "%"


func _on_pressed() -> void:
	if is_equal_approx(_volume_level, 0.0):
		_volume_level = 100.0
	else:
		var decrement_amount := 100.0 / float(n_increments)
		_volume_level = maxf(_volume_level - decrement_amount, 0.0)
	
	var bus_idx := AudioServer.get_bus_index(audio_bus)
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(_volume_level / 100.0))
	_update_text()
