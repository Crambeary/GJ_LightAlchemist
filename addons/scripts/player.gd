extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


@export var Projectile : PackedScene
@export var health := 4
@export var teleport_time := 0.5

const SPEED = 100.0

signal health_depleated

var isTeleporting := false
var is_teleporting_time = teleport_time

func _physics_process(delta: float) -> void:
    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var direction := Input.get_vector("left", "right", "up", "down")
    
    if not isTeleporting:
        if direction.x > 0:
            # Determine which direction we are facing. Use Flip H And offset -1 for left facing
            animated_sprite_2d.offset.x = 1
            animated_sprite_2d.flip_h = false
        elif direction.x < 0:
            animated_sprite_2d.offset.x = -1
            animated_sprite_2d.flip_h = true
            
        if direction:
            animated_sprite_2d.play("Run")
        else:
            animated_sprite_2d.play("idle")
        
        
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
    var b = Projectile.instantiate()
    owner.add_child(b)
    b.transform = $Hand/Sprite2D/Marker2D.global_transform

func take_damage(amount: int) -> void:
    health = health - amount
    if health <= 0:
        health_depleated.emit()
