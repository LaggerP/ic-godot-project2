extends Node

var levels_dict: Dictionary =  {
	"level_1": preload("res://scenes/levels/level_1.tscn"),
	"level_2": preload("res://scenes/levels/level_2.tscn"),
	"level_3": preload("res://scenes/levels/level_3.tscn"),
	"level_4": preload("res://scenes/levels/level_4.tscn")
}
var actual_level
var drop_count: float
var timeout: bool
var is_on_menu: bool = false
var is_paused: bool = false

@onready var current_level: Node = get_tree().current_scene

func _ready() -> void:
	add_to_group("game_manager")
	if current_level.get_name() == "Menu":
		start_level(0)
	else:
		var level = current_level as Level
		actual_level = level.get_level()
		start_level(actual_level)

func start_level(selected_level = 0):
	if selected_level > 0:
		var scene = levels_dict["level_"+str(selected_level)]
		if scene is PackedScene:  # Nos aseguramos que el nivel sea realmente un PackedScene, sin esto romperia el juego
			var new_level = scene.instantiate()
			actual_level = new_level.get_level()
			current_level = new_level
			get_tree().change_scene_to_packed(scene)
	else:
		get_tree().change_scene_to_packed(preload("res://scenes/levels/main_menu.tscn"))
		is_on_menu = true
		actual_level = 0
	
func obtain_drop(drop: Node3D):
	drop_count += 1
	get_tree().call_group("ui_events", "update_score")

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
	timeout = true
	get_tree().call_group("ui_events", "show_score_lose_ui")
	
func reset_level():   
	print_debug("Reseteando el timeout y el drop_count")
	timeout = false
	drop_count = 0
	get_tree().call_group("ship_events", "block_ship_movement")
	get_tree().call_group("ui_events", "show_lose_level_ui")

func pause_menu():
	if is_paused:
		is_paused = false
		get_tree().call_group("ship_events", "block_ship_movement")
		get_tree().call_group("ui_events", "show_pause_ui")
	else:
		is_paused = true
		get_tree().call_group("ship_events", "activate_ship_movement")
		get_tree().call_group("ui_events", "hide_pause_ui")

## Llamar a este método desde el colission del muelle para cambiar de nivel
func next_level():
	get_tree().call_group("ui_events", "hide_score_ui")
	if not timeout:
		timeout = false
		print_debug("Pasamos del nivel: ", actual_level, " al ", actual_level + 1)
		actual_level += 1
		drop_count = 0
		if levels_dict.size() < actual_level: 
			get_tree().call_group("ship_events", "block_ship_movement")
			get_tree().call_group("ui_events", "show_win_game_ui")
			get_tree().call_group("ui_events", "stop_timer")
			return

		get_tree().call_group("ui_events", "show_win_level_ui")
		get_tree().call_group("ship_events", "block_ship_movement")
		get_tree().call_group("ui_events", "stop_timer")

func is_level_finished() -> bool:
	return drop_count >= drops_to_get()
	
func get_actual_level() -> int:
	return actual_level
	
func drops_to_get() -> int:
	var level = current_level as Level
	return level.get_total_drops_required()
	
func reset_game():
	actual_level = 1
	drop_count = 0
	is_on_menu = true
