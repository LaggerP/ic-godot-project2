extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.speed_slowed()
		pass
	pass # Replace with function body.


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.speed_resume()
		pass
	pass # Replace with function body.
