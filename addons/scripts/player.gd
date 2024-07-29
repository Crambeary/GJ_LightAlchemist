extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hand_animation: AnimatedSprite2D = $Hand/CollisionShape2D/AnimatedSprite2D
@onready var walking_dust: AnimatedSprite2D = $"Walking Dust"
@onready var flash_hit: AnimationPlayer = $FlashHit
@onready var ui: CanvasLayer = %UI



@export var Projectile : PackedScene
@export var max_health := 8
@export var teleport_time := 0.5




const SPEED = 100.0

signal health_depleated

var isTeleporting := false
var is_teleporting_time := teleport_time
var shoot_on_cooldown := false
var health := max_health

func _physics_process(delta: float) -> void:
    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var direction := Input.get_vector("left", "right", "up", "down")
    
    if not isTeleporting:
        if direction.x > 0:
            # Determine which direction we are facing. Use Flip H And offset -1 for left facing
            animated_sprite_2d.offset.x = 1
            animated_sprite_2d.flip_h = false
            walking_dust.offset.x = 0
            walking_dust.flip_h = false
        elif direction.x < 0:
            animated_sprite_2d.offset.x = -1
            animated_sprite_2d.flip_h = true
            walking_dust.offset.x = 18
            walking_dust.flip_h = true
            
        if direction:
            animated_sprite_2d.play("Run")
            walking_dust.play("default")
            walking_dust.show()
        else:
            animated_sprite_2d.play("idle")
            walking_dust.hide()
            walking_dust.stop()
        
        
        velocity = direction * SPEED
        
    move_and_slide()
    
    if Input.is_action_just_pressed("shoot"):
        shoot()
        
    if Input.is_action_just_pressed("teleport") && direction:
        isTeleporting = true
        animated_sprite_2d.play("invisible")

        
    if isTeleporting:
        var _invisible_duration := animated_sprite_2d.sprite_frames.get_frame_duration("invisible", 0) 
        var _invisible_length := animated_sprite_2d.sprite_frames.get_frame_count("invisible")
        var _invisible_speed := animated_sprite_2d.sprite_frames.get_animation_speed("invisible")
        var _invisible_time := _invisible_duration * _invisible_length / _invisible_speed
        velocity = Vector2(0,0)
    
        if is_teleporting_time > 0:
            is_teleporting_time -= delta
        else:
            isTeleporting = false
            is_teleporting_time = teleport_time
        
        if is_teleporting_time < _invisible_time:
            translate(direction * (SPEED * delta * 1.8))
            animated_sprite_2d.play_backwards("invisible")
    
func shoot():
    if not shoot_on_cooldown:
        var b = Projectile.instantiate()
        owner.add_child(b)
        b.transform = $Hand/CollisionShape2D/AnimatedSprite2D/Marker2D.global_transform
        hand_animation.play("bloom")
        shoot_on_cooldown = true

func take_damage(amount: int) -> void:
    $SFX_Hurt.play()
    health = health - amount
    ui.update_health(health)
    flash_hit.play("hit")
    animated_sprite_2d.modulate.r = 255 /(health - max_health)
    if health <= 0:
        health_depleated.emit()

func _on_hand_animation_finished() -> void:
    hand_animation.play("idle")
    shoot_on_cooldown = false
