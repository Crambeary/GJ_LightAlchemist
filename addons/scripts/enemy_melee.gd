extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	
	# Get player location relative to me
	
	# Set direction towards player.
	
	# Is there a pathfinding package I can use?

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * SPEED

	move_and_slide()
