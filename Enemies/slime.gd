extends CharacterBody2D

@onready var animations = $AnimatedSprite2D
@export var speed = 20
@export var endMarker: Marker2D

var limit = 1
var startPosition
var endPosition

func _ready():
	startPosition = position
	endPosition = endMarker.global_position
	

func changeDirection():
	var tempEnd = endPosition
	endPosition = startPosition
	startPosition = tempEnd

func updateVelocity():
	var moveDirection = endPosition - position
	if moveDirection.length() < limit:
		changeDirection()
	velocity = moveDirection.normalized() * speed
	
func updateAnimations():
	var animationString = "walkUp"
	if velocity.y > 0:
		animationString = "walkDown"
	elif velocity.x < 0:
		animationString = "walkLeft"
	elif velocity.x > 0:
		animationString = "walkRight"
	animations.play(animationString)

func _physics_process(delta):
	updateVelocity()
	move_and_slide()
	updateAnimations()
	
	
