extends Node

var level_dictionary: Dictionary = {"1": 1, "2": 1, "3": 1}
var levels_dict: Dictionary = {}
var actual_level = 1
var drop_count: float
var timeout: bool

@onready var current_scene: Node = get_tree().current_scene
@onready var main_scene = get_tree().root.get_node("Main")

func _ready() -> void:
	add_to_group("game_manager")
	levels_dict["level_1"] = preload("res://scenes/levels/lvl_1.tscn")
	levels_dict["level_2"] = preload("res://scenes/levels/lvl_1.tscn")
	start_level("level_1")

func start_level(level_name: String):
	if levels_dict.has(level_name):
		var scene = levels_dict[level_name]
		if scene is PackedScene:  # Nos aseguramos que el nivel sea realmente un PackedScene, sin esto romperia el juego
			var level_container = main_scene.get_node("LevelContainer")
			
			 # Eliminar los niveles actuales dentro del LevelContainer si ya existen
			for child in level_container.get_children():
				child.queue_free()  # Eliminar todos los niveles actuales
				
			var new_level = scene.instantiate()
			level_container.add_child(new_level)
		else:
			print("El valor no es una PackedScene válida: ", level_name)
	else:
		print("No hay un nivel válido")
	
func obtain_drop(drop: Node3D):
	drop_count += 1
	get_tree().call_group("ui_events", "update_score")
	get_tree().call_group("spawner_events", "update_drops_size", drop)

func obtain_power_up(type: String, drop: Node3D):
	if type == "velocity":
		#aumentamos la velocidad del barco
		get_tree().call_group("ship_events", "increment_speed")
	if type == "time":
		#agregamos 5 segundos al timer
		get_tree().call_group("ui_events", "add_seconds_to_timer", 5)

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
	get_tree().call_group("level_events", "reset_level")
	get_tree().call_group("ship_events", "block_ship_movement")
	get_tree().call_group("ui_events", "show_loose_level_ui")

## Llamar a este método desde el colission del muelle para cambiar de nivel y spawnear a todos los nuevos drops
func next_level():
	if not timeout:
		timeout = false
		print_debug("Pasamos del nivel: ", actual_level, " al ", actual_level + 1)
		actual_level += 1
		drop_count = 0
		if level_dictionary.size() < actual_level: 
			get_tree().call_group("ship_events", "block_ship_movement")
			get_tree().call_group("ui_events", "show_win_game_ui")
			get_tree().call_group("ui_events", "stop_timer")
			return

		get_tree().call_group("ui_events", "show_win_level_ui")
		get_tree().call_group("ship_events", "block_ship_movement")
		get_tree().call_group("ui_events", "stop_timer")
		

	
func is_level_finished() -> bool:
	# Estas dos lineas de codigo evitan que el juego crashee si level_dictonary no posee mas items
	var drop_to_finish = level_dictionary[str(actual_level)]
	if drop_to_finish == null: true
	return drop_count >= drop_to_finish
