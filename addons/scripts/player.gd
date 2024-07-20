extends CharacterBody2D
@export var Projectile : PackedScene
@export var health := 4

const SPEED = 100.0

signal health_depleated


func _physics_process(delta: float) -> void:
    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    velocity = direction * SPEED
    
    move_and_slide()
    
    if Input.is_action_just_pressed("shoot"):
        shoot()
    
func shoot():
    var b = Projectile.instantiate()
    owner.add_child(b)
    b.transform = $Hand/Sprite2D/Marker2D.global_transform

func take_damage(amount: int) -> void:
    health = health - amount
    if health <= 0:
        health_depleated.emit()
