extends Area2D


var entered = false


func _on_body_entered(body):
	if body.name == "Player":
		entered = true


func _on_body_exited(body):
	if body.name == "Player":
		entered = false

func _process(delta):
	if entered == true:
		if self.name == "GoToForest":
			get_tree().change_scene_to_file("res://Scenes/Forest.tscn")
		elif self.name == "GoToStartArea":
			get_tree().change_scene_to_file("res://Scenes/start_area.tscn")
		#add psotion into golbal and check entered from where
		
