extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var orb = preload("res://OrbSpawner.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartWave_timeout():
	# Replace with star wave function
	var new_orb = orb.instance()
	new_orb.global_transform = $VampireSpawn.global_transform
	add_child(new_orb)
