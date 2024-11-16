extends CanvasLayer

@onready var animation_player: AnimationPlayer = $HFlowContainer/BoxContainer/AnimationPlayer
@onready var score_label: Label = $HFlowContainer/BoxContainer/Control2/BannerHanging/score


func _ready() -> void:
	add_to_group("ui_events")
	score_label.text = "0/" + str(GameManager.level_dictionary[str(GameManager.actual_level)])
	
func update_score():
	score_label.text = str(GameManager.drop_count) + "/" + str(GameManager.level_dictionary[str(GameManager.actual_level)])
	pass
	
func show_score_win_ui():
	animation_player.play("win_level")
	
func reset_score_win_ui():
	score_label.text = str(GameManager.drop_count) + "/" + str(GameManager.level_dictionary[str(GameManager.actual_level)])
