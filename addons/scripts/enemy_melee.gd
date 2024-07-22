extends CharacterBody2D
@onready var Player: CharacterBody2D = %Player
@onready var melee_cooldown: Timer = $"Melee Cooldown"

@export var max_distance := 200
@export var health = 4
@export var melee_distance = 30


const SPEED = 50.0



func _physics_process(delta: float) -> void:
	var direction := Vector2(0,0)
	# Get player location relative to me
	var EnemyToPlayer = Player.position - position
	if EnemyToPlayer.length() < max_distance:
		# We move on to the next step.
		direction = EnemyToPlayer.normalized()
	
	if EnemyToPlayer.length() < melee_distance && melee_cooldown.is_stopped():
		melee()
	
	# TODO: Is there a pathfinding package I can use?
	velocity = direction * SPEED

	move_and_slide()

func take_damage(amount: int) -> void:
	health = health - amount
	if health <= 0:
		queue_free()

func melee() -> void:
	# Swing at player for 2 damage
	# We only execute this when in range, but maybe it's worth confirming for safety?
	melee_cooldown.start()
	print("Melee")
	Player.take_damage(2)
	
	
