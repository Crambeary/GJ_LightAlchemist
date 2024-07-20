extends Area2D
var speed = 200


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
    position += transform.x * speed * delta
    


func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("mobs"):
        body.take_damage(2)
    queue_free()
    pass # Replace with function body.
