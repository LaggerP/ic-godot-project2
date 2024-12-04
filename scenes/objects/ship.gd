extends RigidBody3D

# Velocidad de movimiento
@export var move_speed: float = 5.0
# Velocidad de rotación de la cámara
@export var rotation_speed: float = .9
# Sensibilidad de la camara, mientras mas alto, mas rápido rota
@export var camara_sensibility: float = 3

@export var float_force := 1.0
@export var water_drag := 0.05
@export var water_angular_drag := 0.05
@export var slowing_speed = 1.5

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var water: MeshInstance3D = $"../Water"

@onready var probes = $ProbeContainer.get_children()
@onready var speed_timer: Timer = $SpeedTimer

var submerged: bool = false
var can_move: bool = true
var is_colliding: bool = false
var default_move_speed: float
var touching_seagrass: float = 0

func _ready() -> void:
	default_move_speed = move_speed
	add_to_group("ship_events")

func _physics_process(delta):
	submerged = false
	for p in probes:
		var depth = water.get_height(p.global_position) - p.global_position.y 
		if depth > 0:
			submerged = true
			apply_force(Vector3.UP * float_force * gravity * depth, p.global_position - global_position)
	
	if can_move and !GameManager.is_on_menu:
		movement(delta)
		
	if !GameManager.is_on_menu and Input.is_action_just_pressed("pause"):
		GameManager.pause_menu()

	
func movement(delta):
	# Manejar el movimiento usando las teclas de flecha
	var direction: Vector3 = Vector3.ZERO

	# si choco con la isla no deberia ir para adelante
	if !is_colliding:
		if Input.is_action_pressed("foward"):
			direction += -transform.basis.z  # Ir adelante
	if Input.is_action_pressed("left"): 
		rotation_degrees.y += rotation_speed  # Rotar izquierda
	if Input.is_action_pressed("right"):
		rotation_degrees.y -= rotation_speed  # Rotar derecha

   # Normalizar y aplicar la velocidad
	if touching_seagrass>0:
		direction = direction.normalized() * (move_speed/slowing_speed)
	else:
		direction = direction.normalized() * move_speed
	# Mantener la velocidad vertical para que la gravedad funcione
	direction.y = linear_velocity.y
	# Establecer la velocidad lineal del RigidBody
	linear_velocity = direction
	
	# Movimiento de cámara, solamente para joystick
	if Input.is_action_pressed("camara_left") || Input.is_action_pressed("camara_right"):
		var joystick_index = 0
		var right_stick_x = Input.get_joy_axis(joystick_index, JOY_AXIS_RIGHT_X)
		$CamaraPivot.rotate_y(-right_stick_x * camara_sensibility * delta)

func _integrate_forces(state: PhysicsDirectBodyState3D):
	if submerged:
		state.linear_velocity *=  1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag 

func increment_speed():
	speed_timer.start()
	move_speed += 10
	
func _on_speed_timer_timeout() -> void:
	speed_timer.stop()
	move_speed = default_move_speed
	
func block_ship_movement():
	can_move = false

func activate_ship_movement():
	can_move = true
	
func ship_colliding():
	is_colliding = true
	
func ship_not_colliding():
	is_colliding = false

func speed_slowed():
	touching_seagrass+=1
	
func speed_resume():
	touching_seagrass -=1
