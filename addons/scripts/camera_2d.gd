extends Camera2D
class_name Camera

enum MODES { TARGET, TARGET_MOUSE_BLENDED }

@export var target: Node = null
@export var mode: MODES = MODES.TARGET
@export var MAX_DISTANCE: float = 50
@export var SMOOTH_SPEED: float = 1.0

var target_position := Vector2.INF
var fallback_target: Node = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    fallback_target = target


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    match(mode):
        MODES.TARGET:
            if target:
                target_position = target.position
        MODES.TARGET_MOUSE_BLENDED:
            if target:
                var mouse_pos := get_local_mouse_position()
                target_position = (mouse_pos)
                target_position.x = clamp(target_position.x, -MAX_DISTANCE + target_position.x, MAX_DISTANCE + target_position.x)
                target_position.y = clamp(target_position.y, -MAX_DISTANCE + target_position.y, MAX_DISTANCE + target_position.y)
            
    if target_position != Vector2.INF:
        position = position.lerp(target_position, SMOOTH_SPEED * delta)
    
#
    #self.offset = get_local_mouse_position()
func change_mode(new_mode: MODES) -> void:
    mode = new_mode
    

func change_target(new_target: Node) -> void:
    if new_target:
        if target and target.tree_exiting.is_connected(_clear_target):
            target.tree_exiting.disconnect(_clear_target)
        target = new_target
        new_target.tree_exiting.connect(_clear_target)


func _clear_target() -> void:
    target = fallback_target
    change_mode(MODES.TARGET_MOUSE_BLENDED)
