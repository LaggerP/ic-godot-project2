extends Node

var level_dictionary: Dictionary = {"1": 1, "2": 10, "3": 15}
var actual_level = 1
var drop_count: float


func _ready() -> void:
	add_to_group("game_manager")

func obtain_drop(_drop):
	drop_count += 1
	get_tree().call_group("ui_events", "update_score")
	get_tree().call_group("spawner_events", "update_drops_size")


func won_level():
	get_tree().call_group("ui_events", "show_score_win_ui")
	print("Terminó el nivel, ya puede volver al muelle")
	
	
# Llamar a este metodo desde el colission del muelle para cambiar de nivel y spawnear a todos los nuevos drops
func next_level():
	actual_level+=1
	if level_dictionary.size() < actual_level: return
	
	#se deberia mostrar la UI de nivel finalizado
	print("cambiamos de nivel")
	drop_count = 0
	get_tree().call_group("ui_events", "show_win_level_ui")
	

func is_level_finished() -> bool:
	return drop_count >= level_dictionary[str(actual_level)]
