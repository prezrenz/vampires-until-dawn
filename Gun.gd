extends Sprite


onready var bullet = preload("res://Bullet.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
	look_at(get_global_mouse_position())
	change_direction()


func change_direction():
	var rot = owner.get_rotation_degrees_clamped(get_global_mouse_position(), global_position)
	
	if(rot >= -90 and rot <= 90):
		flip_v = false
	else:
		flip_v = true


func fire():
	var new_bullet = bullet.instance()
	new_bullet.global_transform = $Position2D.global_transform
	print(owner)
	owner.owner.add_child(new_bullet)
