extends CanvasLayer

@onready var win_text: Label = $HFlowContainer/BoxContainer/BoxBrown/PanelBrownDamagedDark/winText

func _ready() -> void:
	add_to_group("ui_events")
	hide()

func show_win_level_ui():
	win_text.text = "Terminaste el nivel " + str(GameManager.actual_level-1)
	show()
	

func _on_next_level_button_down() -> void:
	get_tree().call_group("ui_events", "reset_score_ui")
	get_tree().call_group("ui_events", "reset_timer")
	get_tree().call_group("ship_events", "activate_ship_movement")
	GameManager.start_level(GameManager.get_actual_level())
	hide()


func _on_exit_button_down() -> void:
	hide()
	GameManager.reset_game()
	GameManager.start_level(0)
