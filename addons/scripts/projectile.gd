extends Area2D
var speed = 200

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("mobs"):
		body.take_damage(2)
	
	if not body.is_in_group("player"): # Prevent hitting yourself 
		queue_free()
