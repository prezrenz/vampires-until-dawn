extends CharacterBody2D


@export var default_speed: int = 100
@export var dodge_speed: int = 300
var speed = default_speed

var knockback = Vector2.ZERO

var mouse_pos = Vector2()
var pos = Vector2()
var rot

@export var max_dodge_count: int = 3
var current_dodge_count = 3


func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


func _physics_process(delta):
	change_direction()
	
	if(Input.is_action_just_pressed("fire")):
		$Revolver.fire()
	
	get_movement_input()
	move_and_slide()
	knockback = lerp(knockback, Vector2.ZERO, 0.1)


func change_direction():
	mouse_pos = get_global_mouse_position()
	pos = global_position
	
	rot = rad_to_deg((mouse_pos - pos).angle())
	
	if(rot >= -90 and rot <= 90):
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false


func get_movement_input():
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if(Input.is_action_just_released("dodge") and current_dodge_count > 0):
		speed = dodge_speed
		current_dodge_count -= 1
		$DodgeTimer.start()
	
	velocity = input_dir * speed + knockback


func hurt(direction):
	knockback = direction * 500


func _on_dodge_timer_timeout():
	speed = default_speed


func _on_dodge_recover_timer_timeout():
	if(current_dodge_count < max_dodge_count):
		current_dodge_count += 1


func _on_hitbox_body_entered(body):
	if(body.name == "Vampire"):
		var direction = body.position.direction_to(position)
		hurt(direction)
		body.knockback(-direction)
	if(body.is_in_group("bats")):
		var direction = body.position.direction_to(position)
		hurt(direction)
		body.hurt()
