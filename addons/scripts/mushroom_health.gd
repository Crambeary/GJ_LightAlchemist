extends Area2D

@export var healing_amount := 2


func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"):
        body.heal(healing_amount)
        $AudioStreamPlayer.play()
        queue_free()
