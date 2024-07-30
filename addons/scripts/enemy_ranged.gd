extends CharacterBody2D
@onready var Player: CharacterBody2D = %Player
@onready var ranged_cooldown: Timer = $"Ranged Cooldown"
@onready var ranged_direction: Node2D = $ranged_direction
@onready var marker_2d: Marker2D = $ranged_direction/enemy_ranged_weapon/Marker2D
@onready var animated_sprite_2d: AnimatedSprite2D = $CollisionShape2D/AnimatedSprite2D
@onready var flash_hit: AnimationPlayer = $FlashHit
@onready var bow_sprite: AnimatedSprite2D = $ranged_direction/enemy_ranged_weapon/bow_sprite
@onready var knock_fire: Timer = $knock_fire

@export var Enemy_Projectile : PackedScene
@export var max_distance := 200
@export var player_gap := 70
@export var max_health := 4
@export var ranged_distance := 120


const SPEED = 40.0
var health := max_health
const MOVEMENT_TOLERANCE := 4.0
var is_dead := false
var in_attack := false

func _physics_process(delta: float) -> void:
    if not is_dead:
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
        
        if direction and not in_attack:
            animated_sprite_2d.play("run")
        else:
            animated_sprite_2d.play("idle")
                
        if direction.x > 0:
            # Determine which direction we are facing. Use Flip H And offset -1 for left facing
            animated_sprite_2d.flip_h = false
        elif direction.x < 0:
            animated_sprite_2d.flip_h = true

        move_and_slide()
        ranged_direction.look_at(Player.global_position)
        
        
func die() -> void:
    animated_sprite_2d.play("death")
    $ranged_direction.hide()
    $ranged_direction/enemy_ranged_weapon/CollisionShape2D.disabled = true
    is_dead = true
    set_collision_layer_value(1, false)
    $ranged_direction/enemy_ranged_weapon.set_collision_layer_value(1, false)


func take_damage(amount: int) -> void:
    flash_hit.play("hit")
    health = health - amount
    if health <= 0:
        die()


func ranged() -> void:
    # Shoot at player for 2 damage
    # We only execute this when in range, but maybe it's worth confirming for safety?
    if knock_fire.is_stopped():
        print("knock")
        bow_sprite.play("knock")
        knock_fire.start()
    
    
func shoot() -> void:
    var b = Enemy_Projectile.instantiate()
    owner.add_child(b)
    b.transform = marker_2d.global_transform


func _on_animated_sprite_2d_animation_finished() -> void:
    if animated_sprite_2d.animation == "hit":
        in_attack = false


func _on_knock_fire_timeout() -> void:
    print("knock_timeout")
    in_attack = true
    ranged_cooldown.start()
    shoot()
    animated_sprite_2d.play("hit")
    bow_sprite.play("empty")
    pass # Replace with function body.
