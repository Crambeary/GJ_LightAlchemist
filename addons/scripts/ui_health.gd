extends HBoxContainer

var heart_full := preload("res://addons/sprites/ui/health/Hearts_Red_1.png")
var heart_half := preload("res://addons/sprites/ui/health/Hearts_Red_3.png")
var heart_empty := preload("res://addons/sprites/ui/health/Hearts_Red_5.png")

func update_health(value):
    update_partial(value)

func update_partial(value):
    for i in get_child_count():
        if value > i * 2 + 1:
            get_child(i).texture = heart_full
        elif value > i * 2:
            get_child(i).texture = heart_half
        else:
            get_child(i).texture = heart_empty
