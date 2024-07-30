extends Node2D
@onready var player: CharacterBody2D = %Player

func _ready() -> void:
    Events.checkpoint_entered.connect(func(checkpoint):
        $PlayerSpawn.global_position = checkpoint.global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    
    if Input.is_action_just_pressed("pause"):
        get_viewport().set_input_as_handled()
        if get_tree().paused == false:
            get_tree().paused = true
            $PauseMenu.visible = true


func game_over() -> void:
    #get_tree().reload_current_scene()
    player.position = $PlayerSpawn.position
    player.heal(8)


func _on_player_health_depleated() -> void:
    game_over()
