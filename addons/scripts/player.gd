extends CharacterBody2D
@onready var camera_2d: Camera2D = $Camera2D


const SPEED = 200.0


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * SPEED
	
	move_and_slide()
	
	camera_2d.offset = camera_2d.get_local_mouse_position()
