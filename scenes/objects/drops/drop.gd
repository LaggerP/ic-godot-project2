extends Node3D
class_name Drop

func _on_drops_player_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		$drops/DropCollision.disabled
		$Label3D.text = "OK"
		GameManager.obtain_drop(self)
		# Deshabilitar la colisión del drop para que no pueda volver a interactuar
		$AnimationPlayer.play("Sink")
		await get_tree().create_timer(3).timeout
		queue_free()
