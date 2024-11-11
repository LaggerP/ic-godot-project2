extends Node

var level_dictionary: Dictionary = {"1": 5, "2": 10, "3": 15}
var actual_level: String
var drop_count: float


func _ready() -> void:
	add_to_group("game_manager")
	actual_level = "1"

func get_drop(drop):
	drop_count += 1
	get_tree().call_group("ui_events", "update_score")
	get_tree().call_group("spawner_events", "update_drops_size")


func won_level():
	print("Terminó el nivel, ya puede volver al muelle")
