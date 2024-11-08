extends Area3D

@export var drops: Array[PackedScene]
@export var player: RigidBody3D
@export var min_distance: float = 10.0  # Distancia a la que se instanciará el objeto
@export var max_distance: float = 100.0  # Distancia a la que se instanciará el objeto
@export var min_distance_between_drops: float = 70.0  # Distancia minima que deben tener los drops entre sí

# Almacenamos las posiciones que actualmente estan siendo ocupadas por los drops
var already_positions: Array  = []

func _ready() -> void:
	for drop in drops:
		spawn_drop(drop)

func _process(delta: float) -> void:
	pass

func spawn_drop(drop) -> void:
	if drop:
		var distance = randf_range(min_distance, max_distance)
		var random_distance = Vector3(randf_range(-1.0, 1.0), 0, randf_range(-1.0, 1.0)).normalized()
		#var random_distance = Vector3(randf() - 0.5, 0, randf() - 0.5).normalized()
		var position =  player.global_transform.origin + (random_distance * distance)
			
		for pos in already_positions:
			if pos.distance_to(position) < min_distance_between_drops:
				print("Posición ocupada, reintentando...")
				return spawn_drop(drop)  # Reintentar con una nueva posición
		
		var d = drop.instantiate()
		d.global_position = position
		add_child(d)
		already_positions.append(position)
