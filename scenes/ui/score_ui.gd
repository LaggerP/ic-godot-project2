extends CanvasLayer

var seconds: int = 60

@onready var animation_player: AnimationPlayer = $HFlowContainer/BoxContainer/AnimationPlayer
@onready var score_label: Label = $HFlowContainer/BoxContainer/Control2/BannerHanging/score
@onready var seconds_label: Label = $HFlowContainer/BoxContainer/BoxBrown/ButtonBrown/seconds

@onready var timer: Timer = $Timer


func _ready() -> void:
	add_to_group("ui_events")
	score_label.text = "0/" + str(GameManager.level_dictionary[str(GameManager.actual_level)])
	reset_timer()
	
func _process(delta: float) -> void:
	seconds_label.text = "%02d" % second_left_to_loose()

func second_left_to_loose():
	var time_left = timer.get_time_left()
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
	timer.start()
	
func stop_timer():
	timer.stop()
