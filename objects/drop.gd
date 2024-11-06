extends Node3D
class_name Drop

func _on_drops_player_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		$Label3D.text = "OK"
		for d in $drops.get_children():
			if d.is_class("RigidBody3D"):
				d.queue_free()
		
		await get_tree().create_timer(3).timeout
		queue_free()
	pass
