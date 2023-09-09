extends CharacterBody2D

@onready var animations = $AnimationPlayer
@onready var healthBar = $HealthBar
@export var speed = 20
@export var endMarker: Marker2D
@export var knockBackPower:int = 200

var limit = 1
var startPosition
var endPosition
var moveDirection
var slimeHealth = 50
var player = null
var playerChase:bool = false
var playerCanAttack:bool = false
var attacked:bool = false

func _ready():
	startPosition = position
	endPosition = endMarker.global_position

func changeDirection():
	var tempEnd = endPosition
	endPosition = startPosition
	startPosition = tempEnd

func updateVelocity():
	if playerChase:
		moveDirection = player.position - position
	else:
		moveDirection = endPosition - position
		if moveDirection.length() < limit: # if the distance to end point is lesser than 1 change directions
			changeDirection()
	velocity = moveDirection.normalized() * speed
	
func updateAnimations(): #same as the updateAnimation in player's script
	if velocity.length() == 0:
		animations.stop()
	else:
		var animationString = "walkUp"
		if velocity.y > 0:
			animationString = "walkDown"
		elif velocity.x < 0:
			animationString = "walkLeft"
		elif velocity.x > 0:
			animationString = "walkRight"
		animations.play(animationString)
		
func knockBack():
	var knockBackDirection = - velocity.normalized()*knockBackPower
	velocity = knockBackDirection
	move_and_slide()
		
func updateHealth():
	healthBar.value = slimeHealth

func _physics_process(delta):
	updateVelocity()
	handleDamage() # add smth similar to player to prevnt 
	move_and_slide()
	updateAnimations()
	updateHealth()

func _on_vision_body_entered(body):
	if body.name =="Player":
		player = body
		playerChase = true

func _on_vision_body_exited(body):
	if body.name =="Player":
		player = null
		playerChase = false

func handleDamage():
#	print(slimeHealth)
	if playerCanAttack and PlayerVariables.playerCurrentAttack == true:
		if attacked == false: #To prevent insta killing
			knockBack()
			attacked = true
#			print(self.name,slimeHealth)
			slimeHealth -= 10
			if slimeHealth <= 0:
				self.queue_free()

func _on_slime_hit_box_area_entered(area):
	if area.name == "Weapons":
		playerCanAttack=true

func _on_slime_hit_box_area_exited(area):
	if area.name == "Weapons":
		attacked = false
		playerCanAttack= false
