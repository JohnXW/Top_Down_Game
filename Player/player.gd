extends CharacterBody2D

@export var speed = 100

func handleInput():
	var movedirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = movedirection * speed
	
func _physics_process(delta):
	handleInput()
	move_and_slide()
