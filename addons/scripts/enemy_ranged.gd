extends CharacterBody2D
@onready var Player: CharacterBody2D = %Player
@onready var ranged_cooldown: Timer = $"Ranged Cooldown"
@onready var enemy_ranged_weapon: Area2D = $enemy_ranged_weapon
@onready var ranged_direction: Node2D = $ranged_direction
@onready var marker_2d: Marker2D = $ranged_direction/enemy_ranged_weapon/Marker2D

@export var Enemy_Projectile : PackedScene
@export var max_distance := 200
@export var player_gap := 70
@export var health := 4
@export var ranged_distance := 120


const SPEED = 40.0
const MOVEMENT_TOLERANCE := 4.0

func _physics_process(delta: float) -> void:
    var direction := Vector2(0,0)
    # Get player location relative to me
    var EnemyToPlayer = Player.position - position
    if EnemyToPlayer.length() < max_distance and EnemyToPlayer.length() > player_gap + MOVEMENT_TOLERANCE:
        # We move on to the next step.
        direction = EnemyToPlayer.normalized()
    elif EnemyToPlayer.length() < player_gap - MOVEMENT_TOLERANCE:
        direction = EnemyToPlayer.normalized().rotated(PI) #rotate the vector 180 deg
    
    if EnemyToPlayer.length() < ranged_distance && ranged_cooldown.is_stopped():
        ranged()
    
    # TODO: Is there a pathfinding package I can use?
    velocity = direction * SPEED

    move_and_slide()
    ranged_direction.look_at(Player.global_position)

func take_damage(amount: int) -> void:
    health = health - amount
    if health <= 0:
        queue_free()

func ranged() -> void:
    # Shoot at player for 2 damage
    # We only execute this when in range, but maybe it's worth confirming for safety?
    shoot()
    ranged_cooldown.start()
    
func shoot() -> void:
    var b = Enemy_Projectile.instantiate()
    owner.add_child(b)
    b.transform = marker_2d.global_transform
