extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.has_feature("web"):
		$QuitButton.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PlayButton_button_up():
	get_tree().change_scene("res://Game.tscn")


func _on_QuitButton_button_up():
	get_tree().quit(0)
