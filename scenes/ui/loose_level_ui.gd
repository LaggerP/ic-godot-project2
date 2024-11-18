extends CanvasLayer


func _ready() -> void:
	add_to_group("ui_events")
	$".".hide()
	
func show_loose_level_ui():
	$".".show()

func _on_retry_button_down() -> void:
	get_tree().call_group("ui_events", "reset_score_ui")
	get_tree().call_group("ui_events", "reset_timer")
	$".".hide()


func _on_exit_button_down() -> void:
	get_tree().quit()
	pass # Replace with function body.
