extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    
    if Input.is_action_just_pressed("pause"):
        get_viewport().set_input_as_handled()
        if get_tree().paused == false:
            get_tree().paused = true
            $PauseMenu.visible = true


func game_over() -> void:
    get_tree().reload_current_scene()


func _on_player_health_depleated() -> void:
    game_over()
