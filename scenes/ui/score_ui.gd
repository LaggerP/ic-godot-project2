extends CanvasLayer

var seconds: int = 60

@onready var animation_player: AnimationPlayer = $HFlowContainer/BoxContainer/AnimationPlayer
@onready var score_label: Label = $HFlowContainer/BoxContainer/Control2/BannerHanging/score
@onready var seconds_label: Label = $HFlowContainer/BoxContainer/BoxBrown/ButtonBrown/seconds
@onready var game_timer: Timer = $GameTimer
var drops_to_get = 0

func _ready() -> void:
	add_to_group("ui_events")
	
func _process(delta: float) -> void:
	seconds_label.text = time_left_to_lose()

func time_left_to_lose() -> String:
	var time_elapsed = game_timer.get_time_left()
	var minutes = time_elapsed / 60
	var seconds = fmod(time_elapsed, 60)
	return "%02d:%02d" % [minutes, seconds]

func update_score():
	score_label.text = str(GameManager.drop_count) + "/" + str(drops_to_get)
	
func show_score_win_ui():
	animation_player.play("win_level")
	
func show_score_lose_ui():
	animation_player.play("lose_level")

#TODO VER SI ES NECESARIO TENERLO
func reset_score_ui():
	score_label.text = str(GameManager.drop_count) + "/" + str(drops_to_get)

func reset_drops(_drops):
	drops_to_get = _drops
	score_label.text = "0/" + str(drops_to_get)

func _on_timer_timeout() -> void:
	GameManager.lose_level()
	
func reset_timer(seconds: float):
	game_timer.set_wait_time(seconds)
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
	
