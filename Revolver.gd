extends Sprite2D


@onready var bullet = preload("res://Bullet.tscn")
@onready var root = get_parent().get_parent()

var mouse_pos = Vector2()
var gun_pos = Vector2()
var rot


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_pos = get_global_mouse_position()
	gun_pos = global_position
	
	look_at(get_global_mouse_position())
	
	rot = rad_to_deg((mouse_pos - gun_pos).angle())
	
	if(rot >= -90 and rot <= 90):
		flip_v = false
	else:
		flip_v = true


func fire():
	var new_bullet = bullet.instantiate()
	new_bullet.transform = $Marker2D.global_transform
	root.add_child(new_bullet)
	
