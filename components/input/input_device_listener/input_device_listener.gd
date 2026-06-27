extends Node


signal switched_device(type: Device)

enum Device {
	NONE,
	KBM,
	CONTROLLER,
	TOUCH
}

const MOUSE_DISTANCE_THRESHOLD = 2.0
const JOYSTICK_AXIS_THRESHOLD = 0.5

var _current_device: Device = Device.NONE
var _mouse_over_keyboard: bool = false


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and not _is_mobile():
		if (event as InputEventMouseMotion).relative.length() > MOUSE_DISTANCE_THRESHOLD:
			_set_device(Device.KBM)
			_mouse_over_keyboard = true
	elif event is InputEventKey or event is InputEventMouse and not _is_mobile():
		if event is InputEventKey:
			_mouse_over_keyboard = false
		_set_device(Device.KBM)
	elif event is InputEventJoypadButton:
		_set_device(Device.CONTROLLER)
	elif event is InputEventJoypadMotion:
		if absf((event as InputEventJoypadMotion).axis_value) > JOYSTICK_AXIS_THRESHOLD:
			_set_device(Device.CONTROLLER)
	elif event is InputEventScreenTouch:
		_set_device(Device.TOUCH)
	elif event is InputEventMouseButton and _is_mobile():
		_set_device(Device.TOUCH)


func get_current_device() -> Device:
	return _current_device


func is_kbm_mouse_user() -> bool:
	return _current_device == Device.KBM && _mouse_over_keyboard


func focus_depending_on_device(control: Control) -> void:
	var hide_focus := is_kbm_mouse_user()
	control.grab_focus(hide_focus)


func _set_device(device: Device) -> void:
	if device == _current_device:
		return
	
	_current_device = device
	switched_device.emit(device)


func _is_mobile() -> bool:
	return OS.get_name() == "Android" or OS.get_name() == "iOS"
