extends CanvasLayer

func _ready() -> void:
	add_to_group("ui_events")
	$".".hide()


func show_win_game_ui():
	$".".show()


func _on_exit_button_down() -> void:
	get_tree().quit()
