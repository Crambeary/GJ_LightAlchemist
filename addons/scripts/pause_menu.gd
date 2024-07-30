extends CanvasLayer

func unpause() -> void:
    get_tree().paused = false
    hide()
    

func _on_button_button_down() -> void:
    unpause()
    pass # Replace with function body.


func _input(event: InputEvent):
    if(event.is_action_pressed("pause")):
        get_viewport().set_input_as_handled()
        if get_tree().paused:
            unpause()
