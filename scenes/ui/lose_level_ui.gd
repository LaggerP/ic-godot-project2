extends CanvasLayer


func _ready() -> void:
	add_to_group("ui_events")
	hide()
	
func show_lose_level_ui():
	show()

func _on_retry_button_down() -> void:
	hide()
	get_tree().call_group("ui_events", "reset_score_ui")
	get_tree().call_group("ui_events", "reset_timer")
	get_tree().call_group("ship_events", "activate_ship_movement")
	GameManager.start_level(GameManager.get_actual_level())


func _on_exit_button_down() -> void:
	hide()
	GameManager.reset_game()
	GameManager.start_level(0)
