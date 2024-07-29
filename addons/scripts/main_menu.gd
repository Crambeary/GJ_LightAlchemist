extends MarginContainer

func start_game():
    # Played at the end of the animation "fade_to_black"
    get_tree().change_scene_to_file("res://addons/scenes/levels/game.tscn")

func _on_start_button_down() -> void:
    $VBoxContainer/HBoxContainer/Button/OnClick.play()
    $StartTransition.play("fade_to_black")

func _on_button_mouse_entered() -> void:
    $VBoxContainer/HBoxContainer/Button/OnHover.play()
