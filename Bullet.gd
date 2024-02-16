extends Area2D


export (int) var speed = 750


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("bullets")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += transform.x * speed * delta


func _on_DespawnTimer_timeout():
	queue_free()


func _on_Bullet_body_entered(body):
#	if body is TileMap:
#		queue_free()
	if body.is_in_group("bats"):
		body.queue_free()
	elif body.name == "Vampire":
		var direction = body.position.direction_to(position)
		body.damage(-direction)
	queue_free()
