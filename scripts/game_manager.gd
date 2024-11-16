extends Node

var level_dictionary: Dictionary = {"1": 1, "2": 1, "3": 1}
var actual_level = 1
var drop_count: float

func _ready() -> void:
	add_to_group("game_manager")

func obtain_drop(drop: Node3D):
	drop_count += 1
	get_tree().call_group("ui_events", "update_score")
	get_tree().call_group("spawner_events", "update_drops_size", drop)

func won_level():
	get_tree().call_group("ui_events", "show_score_win_ui")
	print("Terminó el nivel, ya puede volver al muelle")
	
## Llamar a este metodo desde el colission del muelle para cambiar de nivel y spawnear a todos los nuevos drops
func next_level():
	actual_level+=1
	drop_count = 0
	print(level_dictionary.size() < actual_level)
	if level_dictionary.size() < actual_level: 
		get_tree().call_group("ui_events", "show_win_game_ui")
		return
	get_tree().call_group("ui_events", "show_win_level_ui")
	
func is_level_finished() -> bool:
	# Estas dos lineas de codigo evitan que el juego crashee si level_dictonary no posee mas items
	var drop_to_finish = level_dictionary[str(actual_level)]
	if drop_to_finish == null: true
	return drop_count >= drop_to_finish
