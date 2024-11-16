extends CanvasLayer


func _ready() -> void:
	add_to_group("ui_events")
	$".".hide()

func _on_retry_button_down() -> void:
	$".".hide()
