extends Node3D



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and GameManager.is_level_finished():
		GameManager.next_level()
		print_debug("boo")
	pass # Replace with function body.
