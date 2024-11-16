extends Node3D
class_name Drop

## Este valor determina el costo de este drop.
## Mientras mas alto sea el valor, mas tiempo se le dara al jugador para poder agarrarlo.
@export var cost: int = 0

func _on_drops_player_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		$Label3D.text = "OK"
		GameManager.obtain_drop(self)
		# Deshabilitar la colisión del drop para que no pueda volver a interactuar
		$drops/DropCollision.disabled
		$AnimationPlayer.play("Sink")
		await get_tree().create_timer(3).timeout
		queue_free()
	pass
