extends Node

var level_dictionary: Dictionary = {"1": 1, "2": 1, "3": 1}
var actual_level = 1
var drop_count: float
var timeout: bool

func _ready() -> void:
	add_to_group("game_manager")
	
func obtain_drop(drop: Node3D):
	drop_count += 1
	get_tree().call_group("ui_events", "update_score")
	get_tree().call_group("spawner_events", "update_drops_size", drop)

func won_level():
	print_debug("Terminó el nivel, ya puede volver al muelle")
	timeout = false
	get_tree().call_group("ui_events", "show_score_win_ui")
	
func loose_level():
	print_debug("Activando flag timeout")
	timeout = true
	get_tree().call_group("ui_events", "show_score_loose_ui")
	
func reset_level():
	print_debug("Reseteando el timeout y el drop_count")
	timeout = false
	drop_count = 0
	get_tree().call_group("ui_events", "show_loose_level_ui")

## Llamar a este método desde el colission del muelle para cambiar de nivel y spawnear a todos los nuevos drops
func next_level():
	if not timeout:
		timeout = false
		print("Pasamos del nivel: ", actual_level, " al ", actual_level + 1)
		actual_level += 1
		drop_count = 0
		if level_dictionary.size() < actual_level: 
			get_tree().call_group("ui_events", "show_win_game_ui")
			get_tree().call_group("ui_events", "stop_timer")
			return
		get_tree().call_group("ui_events", "show_win_level_ui")
		get_tree().call_group("ui_events", "stop_timer")
		
	
func is_level_finished() -> bool:
	# Estas dos lineas de codigo evitan que el juego crashee si level_dictonary no posee mas items
	var drop_to_finish = level_dictionary[str(actual_level)]
	if drop_to_finish == null: true
	return drop_count >= drop_to_finish
