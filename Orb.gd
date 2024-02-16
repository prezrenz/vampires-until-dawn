extends KinematicBody2D


export (int) var speed = 200
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("orbs")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity += transform.x * speed * delta
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.normal)
		rotation = velocity.angle()
		velocity.x *= 0.9
		velocity.y *= 0.9


func _on_DespawnTimer_timeout():
	queue_free()
