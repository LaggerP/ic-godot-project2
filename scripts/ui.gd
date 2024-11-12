extends Node

@onready var score_label: Label = $"../ScoreUI/HFlowContainer/BannerHanging/score"

func _ready() -> void:
	add_to_group("ui_events")
	%WinUI.hide()
	score_label.text = "0/" + str(GameManager.level_dictionary[str(GameManager.actual_level)])
	
func update_score():
	score_label.text = str(GameManager.drop_count) + "/" + str(GameManager.level_dictionary[str(GameManager.actual_level)])
	
func show_win_ui():
	%WinUI.show()

func _on_contine_button_down() -> void:
	print("siguiente nivel")
	%WinUI.hide()
	pass # Replace with function body.

func _on_exit_button_down() -> void:
	print("ir al menu")
	%WinUI.hide()
	pass # Replace with function body.
