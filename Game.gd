extends Node2D


onready var vampire = preload("res://Vampire.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	$StartWave.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartWave_timeout():
	var new_vampire = vampire.instance()
	new_vampire.global_position = $VampireSpawn.global_position
	add_child(new_vampire)


func _on_WaveTimer_timeout():
	get_node("Vampire").queue_free()
	$BreatheTimer.start()


func _on_BreatheTimer_timeout():
	$StartWave.start()
