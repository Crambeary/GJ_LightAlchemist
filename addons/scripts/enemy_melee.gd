extends CharacterBody2D
@onready var Player: CharacterBody2D = %Player
@onready var melee_cooldown: Timer = $"Melee Cooldown"
@onready var sword_direction: Node2D = $"sword direction"
@onready var animation_player: AnimationPlayer = $"sword direction/AnimationPlayer"
@onready var flash_hit: AnimationPlayer = $FlashHit
@onready var animated_sprite_2d: AnimatedSprite2D = $CollisionShape2D/AnimatedSprite2D


@export var max_distance := 200
@export var min_distance := 35
@export var max_health := 4
@export var melee_distance := 60
@export var melee_damage := 1

var health := max_health
var in_attack := false
const SPEED = 50.0
var is_dead := false


func _physics_process(delta: float) -> void:
    if not is_dead:
        var direction := Vector2(0,0)
        # Get player location relative to me
        var EnemyToPlayer = Player.position - position
        if EnemyToPlayer.length() < max_distance and EnemyToPlayer.length() > min_distance:
            # We move on to the next step.
            sword_direction.look_at(Player.global_position)
            direction = EnemyToPlayer.normalized()
        
        if EnemyToPlayer.length() < melee_distance && melee_cooldown.is_stopped():
            melee()
        
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
        
func die() -> void:
    animated_sprite_2d.play("death")
    $"sword direction".hide()
    $"sword direction/Sword/CollisionShape2D2".disabled = true
    is_dead = true
    set_collision_layer_value(1, false)

func take_damage(amount: int) -> void:
    health = health - amount
    flash_hit.play("hit")
    if health <= 0:
        die()

func melee() -> void:
    # We only execute this when in range, but maybe it's worth confirming for safety?
    melee_cooldown.start()
    animation_player.play("swing")
    animated_sprite_2d.play("hit")
    in_attack = true
    
    
func _on_sword_area_entered(area: Area2D) -> void:
    if area.is_in_group("player"):
        var body = area.get_parent()
        body.take_damage(melee_damage)


func _on_animated_sprite_2d_animation_finished() -> void:
    # if anim_name == "hit":
    if animated_sprite_2d.animation == "hit":
        in_attack = false
