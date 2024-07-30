extends Area2D
var speed = 200


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
    position += transform.x * speed * delta


func _on_area_entered(area: Area2D) -> void:
    if area.is_in_group("player"):
        var body = area.get_parent()
        body.take_damage(2)
    if not area.is_in_group("mobs"):
        queue_free()
    
