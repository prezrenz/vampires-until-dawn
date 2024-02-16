extends KinematicBody2D


export (int) var speed = 5000
onready var player = get_tree().get_nodes_in_group("player")[0]


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("bats")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if is_instance_valid(player):
		velocity = global_position.direction_to(player.global_position) * speed * delta
		velocity = move_and_slide(velocity)


func _on_DespawnTimer_timeout():
	queue_free()
