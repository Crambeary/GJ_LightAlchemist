extends CharacterBody2D
@onready var Player: CharacterBody2D = %Player
@onready var melee_cooldown: Timer = $"Melee Cooldown"
@onready var sword_direction: Node2D = $"sword direction"
@onready var animation_player: AnimationPlayer = $"sword direction/AnimationPlayer"


@export var max_distance := 200
@export var min_distance := 35
@export var max_health := 4
@export var melee_distance := 60

var health := max_health
const SPEED = 50.0

func getPlayer():
	return Player


func _physics_process(delta: float) -> void:
	var direction := Vector2(0,0)
	# Get player location relative to me
	var EnemyToPlayer = Player.position - position
	if EnemyToPlayer.length() < max_distance and EnemyToPlayer.length() > min_distance:
		# We move on to the next step.
		direction = EnemyToPlayer.normalized()
	
	if EnemyToPlayer.length() < melee_distance && melee_cooldown.is_stopped():
		melee()
	
	# TODO: Is there a pathfinding package I can use?
	velocity = direction * SPEED

	move_and_slide()
	sword_direction.look_at(Player.global_position)

func take_damage(amount: int) -> void:
	health = health - amount
	if health <= 0:
		queue_free()

func melee() -> void:
	# Swing at player for 2 damage
	# We only execute this when in range, but maybe it's worth confirming for safety?
	melee_cooldown.start()
	animation_player.play("swing")
	
	
	


func _on_sword_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_sword_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		var body = area.get_parent()
		print("hit")
		body.take_damage(2)
