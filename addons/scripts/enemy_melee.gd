extends CharacterBody2D
@onready var Player: CharacterBody2D = %Player

@export var max_distance := 200


const SPEED = 50.0



func _physics_process(delta: float) -> void:
	var direction := Vector2(0,0)
	# Get player location relative to me
	var EnemyToPlayer = Player.position - position
	if EnemyToPlayer.length() < max_distance:
		# We move on to the next step.
		direction = EnemyToPlayer.normalized()
	# Set direction towards player.
	
	# TODO: Is there a pathfinding package I can use?
	velocity = direction * SPEED

	move_and_slide()
