extends KinematicBody2D


enum state {IDLE, CHASE, SPAWN, ORB, STUN}

export (int) var speed = 4600
export (int) var hits_to_stun = 3
export (int) var bats_to_spawn = 10

var hits_taken = 0

var knockback = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
