extends CharacterBody2D


enum STATE {IDLE, CHASE, SPAWN, STUN}
var current_state = null

@export var hits_to_stun: int = 3
var hits_taken = 0

@export var speed: int = 100

@export var bat_spawn_count = 10
var current_bats = 0

var knockback_force = Vector2.ZERO

@onready var player = get_parent().get_node("Player")
@onready var bat = preload("res://Bat.tscn")
@onready var spawn_point = get_parent().get_node("VampireSpawn")


func _ready():
	set_new_state()
	$SwitchStateTimer.start()


func _process(delta):
	print(current_state)


func _physics_process(delta):
	velocity = Vector2.ZERO
	act()
	move_and_slide()
	knockback_force = lerp(knockback_force, Vector2.ZERO, 0.1)


func _on_SwitchStateTimer_timeout():
	set_new_state()


func set_new_state():
	current_state = randi() % (STATE.size()-1)
	set_state_initialization()


func set_state_initialization():
	$Collider.set_deferred("disabled", false)
	$BatSpawnTimer.stop()
	match current_state:
		STATE.IDLE:
			$SwitchStateTimer.wait_time = 2
		STATE.CHASE:
			$SwitchStateTimer.wait_time = 3
		STATE.SPAWN:
			$SwitchStateTimer.wait_time = 4
			$BatSpawnTimer.start()
		STATE.STUN:
			$SwitchStateTimer.wait_time = 10


func chase():
	velocity = position.direction_to(player.position) * speed + knockback_force


func act():
	match current_state:
		STATE.CHASE:
			chase()
		_:
			velocity = Vector2.ZERO


func spawn():
	if(current_bats < bat_spawn_count):
		var spawn_loc = randi() % 2+1
		var new_bat = bat.instantiate()
		if(spawn_loc == 1):
			new_bat.transform = $BatSpawn1.global_transform
		else:
			new_bat.transform = $BatSpawn2.global_transform
		get_parent().add_child(new_bat)
		current_bats += 1
	$BatSpawnTimer.start()


func stun():
	current_state = STATE.STUN
	set_state_initialization()
	$Collider.set_deferred("disabled", true)
	


func hurt():
	hits_taken += 1
	if(hits_taken == hits_to_stun):
		stun()
	hits_taken = 0


func knockback(direction):
	knockback_force = direction * 500


func _on_hitbox_body_entered(body):
	pass


func _on_bat_spawn_timer_timeout():
	spawn()
