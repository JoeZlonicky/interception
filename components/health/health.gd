class_name Health
extends Node
## Encapsulates a health value between 0 and a maximum.


## Emitted when health decreases to 0.
signal depleted

## Emitted when health increases from 0.
signal revived

## Emitted when health decreases by a positive amount.
signal damaged(amount: int)

## Emitted when health increases by a positive amount.
signal healed(amount: int)

## Emitted when max values changes.
signal max_changed

## Maximum health
@export_range(1, 100, 1, "or_greater") var _max: int = 10

@onready var _current: int = _max


## Get current health.
func get_current() -> int:
	return _current


## Get max health.
func get_max() -> int:
	return _max


## Get current health as a ratio of max health (0 to 1).
func get_ratio() -> float:
	var ratio := float(_current) / float(_max)
	return clampf(ratio, 0.0, 1.0)


## Decreases health by a positive amount.[br]
## Emits [signal damaged] if decreased by >0.[br]
## Emits [signal depleted] if damage resulted in reaching 0 health.
func damage(amount: int) -> void:
	assert(amount >= 0)
	
	if _current <= 0 || amount == 0:
		return
	
	var before := _current
	_current = maxi(_current - amount, 0)
	damaged.emit(before - _current)
	
	if _current == 0:
		depleted.emit()


## Increases health by a positive amount that doesn't increase past max health.[br]
## Emits [signal healed] if increased by >0.[br]
## Emits [signal revived] if increased from 0.
func heal(amount: int) -> void:
	assert(amount >= 0)
	
	if _current == _max or amount == 0:
		return
	
	var before := _current
	_current = mini(_current + amount, _max)
	
	if before == 0:
		revived.emit()
	healed.emit(_current - before)


## Heals to full health. See [method heal] for more details.
func heal_to_full() -> void:
	heal(_max - _current)


## Returns true if current health is greater than 0.
func is_alive() -> bool:
	return _current > 0


## Damages by current health. See [method damage] for more details.
func kill() -> void:
	damage(_current)


## Modifies max health.[br]
## Emits [signal max_changed] if changed to a new value.
func update_max_health(new_value: int) -> void:
	assert(new_value >= 1)
	
	var changed: bool = new_value != _max
	
	_max = new_value
	if _current > _max:
		_current = _max
	
	if changed:
		max_changed.emit()
