extends Node

func _ready() -> void:
	add_to_group("game_manager")

func get_drop(drop):
	print_debug("get_drop ", drop)
	get_tree().call_group("ui_events", "update_score")
