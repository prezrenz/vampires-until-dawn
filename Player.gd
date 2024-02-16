extends KinematicBody2D


export (int) var max_health = 6
export (int) var max_dodges = 3
export (float) var default_dodge_regen = 1
export (int) var max_ammo = 5
export (int) var max_chamber = 5
export (float) var default_reload_speed = 1.0

export (int) var default_speed = 4000
export (int) var dodge_speed = 12000
export (int) var knockback_force = 500

onready var current_health = max_health
onready var current_dodges = max_dodges
onready var current_dodge_regen = default_dodge_regen
onready var current_ammo = max_ammo
onready var current_chamber = max_chamber
onready var current_reload_speed = default_reload_speed

onready var speed = default_speed

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var can_fire = true


# Called when the node enters the scene tree for the first time.
func _ready():
	$DodgeRecoverTimer.wait_time = default_dodge_regen


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_input(delta)
	velocity = move_and_slide(velocity)
	knockback = lerp(knockback, Vector2.ZERO, 0.1)
	change_direction()


func get_rotation_degrees_clamped(mouse_pos, pos):
	return rad2deg((mouse_pos - pos).angle())

func change_direction():
	var rot = get_rotation_degrees_clamped(get_global_mouse_position(), global_position)
	
	if(rot >= -90 and rot <= 90):
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false

func get_input(delta):
	if Input.is_action_just_pressed("fire"):
		fire()
	if Input.is_action_just_pressed("reload"):
		reload()
	if Input.is_action_just_pressed("dodge"):
		dodge()
	
	velocity = Vector2.ZERO
	velocity.x = Input.get_axis("move_left", "move_right")
	velocity.y = Input.get_axis("move_up", "move_down")
	
	velocity = velocity.normalized() * speed * delta + knockback


func fire():
	current_chamber = clamp(current_chamber, 0, max_chamber)
	
	if(!can_fire):
		return # in middle of reload
	
	if(current_chamber == 0):
		return # play sound
	
	current_chamber -= 1
	$Gun.fire()


func reload():
	if(current_ammo < 0):
		return # do not reload, give indication
	
	if(current_chamber == max_chamber):
		return # already full
	
	while(current_ammo > 0 and current_chamber < max_chamber):
		current_ammo -= 1
		current_chamber += 1
	
	can_fire = false
	$ReloadTimer.wait_time = default_reload_speed
	$ReloadTimer.start()


func dodge():
	if current_dodges <= 0:
		return # no dodges left
	
	current_dodges -= 1
	speed = dodge_speed
	$HitBox.set_monitoring(false)
	$DodgeTimer.start()


func die():
	queue_free() # what happens?


func damage(direction):
	if current_health <= 0:
		die()
		return
	
	current_health -= 1
	knockback = direction * knockback_force


func _on_ReloadTimer_timeout():
	can_fire = true # play sound, update ui


func _on_DodgeTimer_timeout():
	speed = default_speed
	$HitBox.set_monitoring(true)


func _on_DodgeRecoverTimer_timeout():
	if current_dodges < max_dodges:
		current_dodges += 1


func _on_HitBox_body_entered(body):
	if body.name == "Vampire":
		var direction = body.position.direction_to(position)
		damage(direction)
		body.hurt(-direction)
	
	elif body.is_in_group("bats"):
		var direction = body.position.direction_to(position)
		damage(direction)
		body.queue_free()
