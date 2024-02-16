extends KinematicBody2D


export (int) var speed = 5000
onready var player = get_tree().get_nodes_in_group("player")[0]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var velocity = Vector2.ZERO
	velocity = global_position.direction_to(player.global_position) * speed * delta
	velocity = move_and_slide(velocity)


func _on_DespawnTimer_timeout():
	queue_free()
