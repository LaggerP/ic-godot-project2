extends Node3D
class_name Level

@export var level_time: float
@export var drops_to_get: float

func _ready() -> void:
	get_tree().call_group("ui_events", "reset_timer", level_time)
	get_tree().call_group("ui_events", "reset_drops", drops_to_get)


func get_drops_to_get() -> float:
	return drops_to_get
