extends Area3D

@export var drops: Array[PackedScene]
@export var player: RigidBody3D
@export var min_distance: float = 30.0  # Distancia a la que se instanciará el objeto
@export var max_distance: float = 100.0  # Distancia a la que se instanciará el objeto
@export var min_distance_between_drops: float = 80.0  # Distancia minima que deben tener los drops entre sí

@onready var spawn_area: CollisionShape3D = $CollisionShape3D


# Almacenamos las posiciones que actualmente estan siendo ocupadas por los drops
var already_positions: Array  = []
# Almacena la posición correspondiente a cada drop
var drop_positions: Dictionary = {}

func _ready() -> void:
	add_to_group("spawner_events")
	for drop in drops:
		spawn_drop(drop)

func spawn_drop(drop) -> void:
	if drop:
		var position_is_valid = false

		# Esta forma no me gusta, pero es la mas rápida que encontre para spawnear sin que el motor se congele
		while not position_is_valid:
			var position = get_random_point_in_area()

			# Verificar distancia mínima al jugador
			if position.distance_to(player.global_transform.origin) < min_distance:
				await get_tree().process_frame
				continue
			
			# Verificar si la posición está ocupada
			position_is_valid = true
			for pos in already_positions:
				if pos.distance_to(position) < min_distance_between_drops:
					print("Posición demasiado cercana a otro drop: Distancia = ",  pos.distance_to(position))
					position_is_valid = false

			# Ceder control al motor para evitar congelamiento
			await get_tree().process_frame

			var d = drop.instantiate()
			d.global_position = position
			add_child(d)
			already_positions.append(position)
			drop_positions[d] = position
			break

func update_drops_size(drop: Node3D) -> void:
	if drop_positions.has(drop):
		var position = drop_positions[drop]
		already_positions.erase(position)
		drop_positions.erase(drop)
		print("Drop recogido y posición eliminada:", position)
	spawn_drop(drops.pick_random())
	if GameManager.is_level_finished():
		GameManager.won_level()

func get_random_point_in_area() -> Vector3:
	var shape = spawn_area.shape
	if shape is BoxShape3D:
		var extents = (shape as BoxShape3D).size / 2
		var random_point = Vector3(
			randf() * extents.x * 2 - extents.x,
			randf() * extents.y * 2 - extents.y,
			randf() * extents.z * 2 - extents.z
		)
		return spawn_area.global_transform * random_point
	else:
		print("La forma del área de generación no es compatible.")
		return player.global_transform.origin  # Retornar posición del jugador como fallback
