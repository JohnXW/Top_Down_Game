extends CharacterBody2D

@onready var dialogBubble = $DialogBubble

func _process(delta):
	dialogBubble.play()


func _on_convo_area_body_entered(body):
	print(body)
	if body.name == "Player":
		dialogBubble.visible = true

func _on_convo_area_body_exited(body):
	if body.name == "Player":
		dialogBubble.visible = false
