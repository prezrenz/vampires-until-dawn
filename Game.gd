extends Node2D


onready var vampire = preload("res://Vampire.tscn")
onready var ammo = preload("res://Ammo.tscn")
var current_wave = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$StartWave.start()
	$UI/WaveStatus.text = "STARTING..."


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func spawn_ammo():
	var centerpos = $AmmoSpawnArea.position
	var size = $AmmoSpawnArea/CollisionShape2D.shape.extents
	
	var random_pos = Vector2(0, 0)
	random_pos.x = (randi() % int(size.x)) - (size.x/2) + centerpos.x
	random_pos.y = (randi() % int(size.y)) - (size.y/2) + centerpos.y
	var new_ammo = ammo.instance()
	new_ammo.position = random_pos
	add_child(new_ammo)


func _on_StartWave_timeout():
	var new_vampire = vampire.instance()
	new_vampire.global_position = $VampireSpawn.global_position
	add_child(new_vampire)
	
	current_wave += 1
	
	if current_wave == 3:
		new_vampire.bats_to_spawn = 12
		new_vampire.speed += 400
		new_vampire.hits_to_stun = 8
	
	$WaveTimer.start()
	$UI/WaveStatus.text = "WAVE " + str(current_wave)


func _on_WaveTimer_timeout():
	$VampireRetreat.play()
	get_node("Vampire").queue_free()
	
	if current_wave == 3:
		$UI/WinScreen.visible = true
		$AmmoSpawnTimer.stop()
		$UI/WaveStatus.text = "THE END..."
	
	$BreatheTimer.start()
	$UI/WaveStatus.text = "RESTING..."


func _on_BreatheTimer_timeout():
	$StartWave.start()
	$UI/WaveStatus.text = "STARTING..."


func _on_Player_update_health(current_health, max_health):
	var hp_str = "Health: " + str(current_health) + "/" + str(max_health)
	$UI/HealthLabel.text = hp_str


func _on_Player_update_dodges(current_dodges, max_dodges):
	var dod_str = "Stamina: " + str(current_dodges) + "/" + str(max_dodges)
	$UI/DodgeLabel.text = dod_str


func _on_Player_update_ammo(current_chamber, current_ammo):
	var ammo_str = "Ammo: " + str(current_chamber) + "/" + str(current_ammo)
	$UI/AmmoLabel.text = ammo_str


func _on_Player_died():
	$UI/DeathScreen.visible = true


func _on_Button_button_up():
	$Select.play()
	get_tree().change_scene("res://ui/MainMenu.tscn")


func _on_AmmoSpawnTimer_timeout():
	var to_spawn = randi() % 2
	
	if to_spawn == 1:
		spawn_ammo()
