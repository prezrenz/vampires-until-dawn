extends Sprite2D


@export var speed: int = 750


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
	position += transform.x * speed * delta


func _on_DespawnTimer_timeout():
	self.queue_free()


func _on_area_2d_body_entered(body):
	if(is_instance_of(body, CharacterBody2D)):
		body.hurt()
