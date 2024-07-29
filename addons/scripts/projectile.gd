extends Area2D
var speed = 200
@onready var explode: GPUParticles2D = $Explode
@onready var color_rect: ColorRect = $ColorRect
var hit = false

func _ready() -> void:
    var pitch = randf_range(0.5, 2.5)
    $SFX_Shoot.set_pitch_scale(pitch)
    $SFX_Shoot.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
    if not hit:
        position += transform.x * speed * delta
    

func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("mobs"):
        body.take_damage(2)
        $SFX_Explode.play()
    
    if not body.is_in_group("player"): # Prevent hitting yourself 
        hit = true
        color_rect.visible = false
        explode.visible = true
        $Timer.start()
        
    

func _on_timer_timeout() -> void:
    queue_free()
    pass # Replace with function body.
