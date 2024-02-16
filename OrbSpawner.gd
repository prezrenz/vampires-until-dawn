extends Node2D


onready var orb = preload("res://Orb.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	pass


func spawn():
	for i in range(3):
		var new_orb = orb.instance()
		var new_position = get_node("Position" + str(i+1))
		new_orb.global_transform = new_position.global_transform
		new_orb.rotation_degrees += randi() % -5 - 5
		get_parent().get_parent().add_child(new_orb)
