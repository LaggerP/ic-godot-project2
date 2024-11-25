extends CanvasLayer

var seconds: int = 60

@onready var animation_player: AnimationPlayer = $HFlowContainer/BoxContainer/AnimationPlayer
@onready var score_label: Label = $HFlowContainer/BoxContainer/Control2/BannerHanging/score
@onready var seconds_label: Label = $HFlowContainer/BoxContainer/BoxBrown/ButtonBrown/seconds
@onready var game_timer: Timer = $GameTimer

@export var default_time_in_seconds = 20


func _ready() -> void:
	add_to_group("ui_events")
	score_label.text = "0/" + str(GameManager.level_dictionary[str(GameManager.actual_level)])
	reset_timer()
	
func _process(delta: float) -> void:
	seconds_label.text = "%02d" % second_left_to_loose()

func second_left_to_loose():
	var time_left = game_timer.get_time_left()
	return int(time_left) % 60

func update_score():
	score_label.text = str(GameManager.drop_count) + "/" + str(GameManager.level_dictionary[str(GameManager.actual_level)])
	
func show_score_win_ui():
	animation_player.play("win_level")
	
func show_score_loose_ui():
	animation_player.play("loose_level")

func reset_score_ui():
	score_label.text = str(GameManager.drop_count) + "/" + str(GameManager.level_dictionary[str(GameManager.actual_level)])

func _on_timer_timeout() -> void:
	GameManager.loose_level()
	
func reset_timer():
	game_timer.set_wait_time(default_time_in_seconds)
	game_timer.start()
	
func stop_timer():
	game_timer.stop()
	
func add_seconds_to_timer(time_seconds: int):
	if time_seconds <= 0: return

	# Actualizamos el tiempo restante del temporizador
	var new_time = max(game_timer.get_time_left() + time_seconds, 0)  # Aseguramos que el tiempo no sea negativo
	game_timer.set_wait_time(new_time)

	# Reiniciamos el temporizador si no está funcionando
	if !game_timer.is_stopped():
		game_timer.start()
	
