extends Node3D
class_name Level

@export_group("Level properties")
# Tiempo límite en segundos para completar el nivel
@export var level_time: float
# Número total de objetos que el jugador debe recolectarel
@export var total_drops_required: float
# Número del nivel
@export var level: int


func _ready() -> void:
	get_tree().call_group("ui_events", "reset_timer", level_time)
	get_tree().call_group("ui_events", "reset_drops")
	get_tree().call_group("ui_events", "show_score_ui")

func get_total_drops_required() -> float:
	return total_drops_required
	
func get_level_time() -> float:
	return level_time

func get_level() -> int:
	return level	
