extends CharacterBody2D
@onready var Player: CharacterBody2D = %Player
@onready var melee_cooldown: Timer = $"Melee Cooldown"
@onready var sword_direction: Node2D = $"sword direction"
@onready var animation_player: AnimationPlayer = $"sword direction/AnimationPlayer"


@export var max_distance := 200
@export var health = 4
@export var melee_distance = 60

var sound_player := AudioStreamPlayer.new()
const SPEED = 50.0

func getPlayer():
	return Player

func _ready() -> void:
	add_child(sound_player)

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
	sword_direction.look_at(Player.global_position)
	if animation_player.is_playing():
		var sound_effect = load("res://path_to_sound_effect.wav")
		sound_player.stream = sound_effect
		sound_player.play()

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
	if body.is_in_group("player"):
		print("hit")
		body.take_damage(2)
