extends KinematicBody2D


enum state {IDLE, CHASE, SPAWN, ORB, STUN}
var current_state = null

export (int) var speed = 4600
export (int) var hits_to_stun = 6
export (int) var bats_to_spawn = 10

export (int) var knockback_force = 200

onready var player = get_tree().get_nodes_in_group("player")[0]
onready var spawn_point = get_parent().get_node("VampireSpawn")


var hits_taken = 0

var knockback = Vector2.ZERO

var velocity = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	set_new_state()
	$StateTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(player):
		process_state(delta)
		velocity = move_and_slide(velocity)
		knockback = lerp(knockback, Vector2.ZERO, 0.1)


func initialize_state():
	$WorldCollider.set_deferred("disabled", false)
	match current_state:
		state.IDLE:
			global_position = spawn_point.global_position
			$StateTimer.wait_time = 1
		state.CHASE:
			$StateTimer.wait_time = 15
		state.SPAWN:
			global_position = spawn_point.global_position
			$WorldCollider.set_deferred("disabled", true)
			$StateTimer.wait_time = 5
			$BatSpawnTimer.start()
		state.STUN:
			$StateTimer.wait_time = 5
		state.ORB:
			global_position = spawn_point.global_position
			$WorldCollider.set_deferred("disabled", true)
			$StateTimer.wait_time = 1
			


func set_new_state(new_state = -1):
	if new_state == -1:
		current_state = randi() % (state.size()-1)
	else:
		current_state = new_state
	initialize_state()


func process_state(delta):
	velocity = Vector2.ZERO
	
	match current_state:
		state.IDLE:
			pass
		state.CHASE:
			velocity = position.direction_to(player.position) * speed * delta + knockback
		state.SPAWN:
			if $BatSpawnTimer.is_stopped():
				$BatSpawnTimer.start()
		state.STUN:
			pass
		state.ORB:
			var orb_count = get_tree().get_nodes_in_group("orbs").size()
			if orb_count < 6:
				$OrbSpawner.spawn()


func stun():
	current_state = state.STUN
	initialize_state()
	$WorldCollider.set_deferred("disabled", true)



func damage(direction):
	if hits_taken >= hits_to_stun:
		stun()
		hits_taken = 0
		return
	
	hits_taken += 1
	knockback = direction * knockback_force


func _on_StateTimer_timeout():
	set_new_state()


func _on_BatSpawnTimer_timeout():
	var bat_count = get_tree().get_nodes_in_group("bats").size()
	if bat_count <= 0:
		$BatSpawner.spawn(bats_to_spawn)
