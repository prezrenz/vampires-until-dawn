extends CharacterBody2D


@export var speed: int = 100
@onready var player = get_parent().get_node("Player")
@onready var vampire = get_parent().get_node("Vampire")


func _physics_process(delta):
	velocity = Vector2.ZERO
	velocity = global_position.direction_to(player.global_position) * speed
	move_and_slide()


func hurt():
	vampire.current_bats -= 1
	queue_free()
