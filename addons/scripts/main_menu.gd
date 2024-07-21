extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
    


func start_game():
    get_tree().change_scene_to_file("res://addons/scenes/levels/game.tscn")

func _on_start_button_down() -> void:
    $StartTransition.play("fade_to_black")
