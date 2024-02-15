extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Orb.rotation_degrees += randi() % 5 - 5
	$Orb2.rotation_degrees += randi() % 5 - 5
	$Orb3.rotation_degrees += randi() % 5 - 5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
