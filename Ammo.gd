extends StaticBody2D


export (int) var amount = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("ammo")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
