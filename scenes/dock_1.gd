extends Node3D



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and GameManager.drop_count>5:
	
		GameManager.won_level()
		print_debug("boo")
	pass # Replace with function body.
