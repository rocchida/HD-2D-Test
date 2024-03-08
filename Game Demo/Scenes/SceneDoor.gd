extends Area3D


var entered = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if entered:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().change_scene_to_file("res://Scenes/battle.tscn")


func _on_body_entered(body: CharacterBody3D):
	entered = true


func _on_body_exited(body: CharacterBody3D):
	entered = false
