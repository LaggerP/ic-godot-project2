extends Node

var levels_dict: Dictionary =  {
	"menu": preload("res://scenes/ui/main_menu.tscn"),
	"level_1": preload("res://scenes/levels/level_1.tscn"),
	"level_2": preload("res://scenes/levels/level_2.tscn")
}
var actual_level = 1
var drop_count: float
var timeout: bool
var is_on_menu: bool = true

@onready var current_scene: Node = get_tree().current_scene
@onready var main_scene = get_tree().root.get_node("Main")

func _ready() -> void:
	add_to_group("game_manager")
	start_level("menu")

func start_level(level_name: String):
	if not is_on_menu: get_tree().call_group("ui_events", "show_score_ui")
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
		get_tree().call_group("ship_events", "block_ship_movement")
		get_tree().call_group("ui_events", "show_win_game_ui")
		get_tree().call_group("ui_events", "stop_timer")
	
func obtain_drop(drop: Node3D):
	drop_count += 1
	get_tree().call_group("ui_events", "update_score")
	get_tree().call_group("spawner_events", "update_drops_size", drop)

func obtain_power_up(type):
	match type:
		Constants.PowerUp.VELOCITY:
			#aumentamos la velocidad del barco
			get_tree().call_group("ship_events", "increment_speed")
		Constants.PowerUp.TIME:
			#agregamos 5 segundos al timer
			get_tree().call_group("ui_events", "add_seconds_to_timer", 5)
		_:
			return
			print_debug("no existe un power up valido")

func won_level():
	print_debug("Terminó el nivel, ya puede volver al muelle")
	timeout = false
	get_tree().call_group("ui_events", "show_score_win_ui")
	
func lose_level():
	print_debug("Activando flag timeout")
	timeout = true
	get_tree().call_group("ui_events", "show_score_lose_ui")
	
func reset_level():   
	print_debug("Reseteando el timeout y el drop_count")
	timeout = false
	drop_count = 0
	get_tree().call_group("ship_events", "block_ship_movement")
	get_tree().call_group("ui_events", "show_lose_level_ui")

## Llamar a este método desde el colission del muelle para cambiar de nivel
func next_level():
	get_tree().call_group("ui_events", "hide_score_ui")
	if not timeout:
		timeout = false
		print_debug("Pasamos del nivel: ", actual_level, " al ", actual_level + 1)
		actual_level += 1
		drop_count = 0
		if levels_dict.size()-1 < actual_level: 
			get_tree().call_group("ship_events", "block_ship_movement")
			get_tree().call_group("ui_events", "show_win_game_ui")
			get_tree().call_group("ui_events", "stop_timer")
			return

		get_tree().call_group("ui_events", "show_win_level_ui")
		get_tree().call_group("ship_events", "block_ship_movement")
		get_tree().call_group("ui_events", "stop_timer")

func is_level_finished() -> bool:
	# Estas lineas de codigo evitan que el juego crashee si level_dictonary no posee mas items
	var level = levels_dict[get_actual_level()] as PackedScene
	if level == null: true
	var level_instance = level.instantiate() as Level
	return drop_count >= level_instance.get_total_drops_required()
	
func get_actual_level() -> String:
	return "level_"+str(actual_level)
	
func reset_game():
	actual_level = 1
	drop_count = 0
	is_on_menu = true
