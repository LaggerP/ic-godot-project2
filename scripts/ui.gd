extends Node

func _ready() -> void:
	add_to_group("ui_events")
	
func update_score():
	print("nuevo drop capturado: update_score")
