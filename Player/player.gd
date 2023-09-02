extends CharacterBody2D

class_name Player

signal healthChange

@export var speed: int = 60
@onready var animations = $AnimationPlayer
@onready var hurtEffect = $HitEffect
@onready var HurtTimer = $HurtTimer
@export var knockBackPower:int = 200
#@onready var currentHP: int = PlayerVariables.currentHP
var playerHurt:bool = false
var enemyCollisions = []
var lol:int = 0
var movedirection
var direction
var playerAttackingInProgress:bool = false

func _ready():
	hurtEffect.play("RESET")

func handleInput():
	movedirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	velocity = movedirection * speed
	
func updateAnimation(): 
	if velocity.length() == 0:
		# add attack anim here
		animations.stop()
	else:
		direction = "down"
		if velocity.x < 0: direction = "left"
		elif velocity.x > 0: direction = "right"
		elif velocity.y < 0: direction = "up"
		
		animations.play("walk_" + direction)
	
#func handleCollision():
#	for i in get_slide_collision_count():
#		var collision = get_slide_collision(i)
#		var collider = collision.get_collider()
##		print_debug(collider.name)

func _physics_process(delta):
	handleInput()
	move_and_slide()
	updateAnimation()
	if !playerHurt: # loops when player is not being damaged
		for enemyArea in enemyCollisions: # calls hurtByEnemy if there r enemies inside players hitbox
			hurtByEnemy(enemyArea)

func hurtByEnemy(area):
	knockBack(area.get_parent().velocity)
	PlayerVariables.currentHP -= 1
	playerHurt = true
	
	if PlayerVariables.currentHP == 0:
		PlayerVariables.currentHP = PlayerVariables.maxHP
	healthChange.emit(PlayerVariables.currentHP) 
	
	hurtEffect.play("hurtBlink")
	HurtTimer.start()
	await HurtTimer.timeout
	hurtEffect.play("RESET")
	playerHurt = false

func _on_hurt_box_area_entered(area):
#	if iFrame: return
	if area.name == "SlimeHitBox": 
		enemyCollisions.append(area)

func knockBack(enemyVelocity: Vector2):
	var knockBackDirection = (enemyVelocity - velocity).normalized()*knockBackPower
	velocity = knockBackDirection
	move_and_slide()


func _on_hurt_box_area_exited(area):
	enemyCollisions.erase(area)
