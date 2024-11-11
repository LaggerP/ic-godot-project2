extends Node

var level_dictionary: Dictionary = {"1": 5, "2": 10, "3": 15}


func _ready() -> void:
	add_to_group("game_manager")

func get_drop(drop):
	print_debug("get_drop ", drop)
	get_tree().call_group("ui_events", "update_score")
	get_tree().call_group("spawner_events", "update_drops_size")


func won_level():
	print("Terminó el nivel, ya puede volver al muelle")
