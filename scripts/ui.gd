extends Node

func _ready() -> void:
	add_to_group("ui_events")
	$HFlowContainer/BannerHanging/score.text = "0/" + str(GameManager.level_dictionary[GameManager.actual_level])
	
func update_score():
	$HFlowContainer/BannerHanging/score.text = str(GameManager.drop_count) + "/" + str(GameManager.level_dictionary[GameManager.actual_level])
