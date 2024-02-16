extends Node2D


onready var bat = preload("res://Bat.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func spawn(count):
	for i in range(count):
		var new_bat = bat.instance()
		
		var spawn_point = randi() % 2
		
		if spawn_point == 0:
			new_bat.global_transform = $Position1.global_transform
		elif spawn_point == 1:
			new_bat.global_transform = $Position2.global_transform
		
		get_parent().add_child(new_bat)
