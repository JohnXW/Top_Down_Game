extends CharacterBody2D

class_name Player

signal healthChange

@export var speed: int = 60
@onready var animations = $AnimationPlayer
@onready var hurtEffect = $HitEffect
@onready var HurtTimer = $HurtTimer
@onready var AttackTImer = $AttackTimer
@onready var Weapon = $Weapons
@export var knockBackPower:int = 200
#@onready var currentHP: int = PlayerVariables.currentHP
var playerHurt:bool = false
var enemyCollisions = []
var movedirection
var direction = "down"
var playerAttackingInProgress:bool = false

func _ready():
	hurtEffect.play("RESET")
	Weapon.visible = false

func handleInput():
	movedirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if playerAttackingInProgress == true:
		velocity = Vector2.ZERO
	else:
		velocity = movedirection * speed

func updateAnimation(): 
	var weaponFlip = Weapon.get_child(0)
	if Input.is_action_just_pressed("ui_attack"):
		Weapon.visible = true
		playerAttackingInProgress = true
		animations.play("attack_" + direction)
		AttackTImer.start()
		await AttackTImer.timeout
		playerAttackingInProgress = false
		Weapon.visible = false
	elif playerAttackingInProgress == false:
		if velocity.length() == 0:
			animations.stop()
		
		else:
			if velocity.x < 0: 
				direction = "left"
				Weapon.rotation_degrees = 90
				Weapon.position = Vector2(-8, -4)
			elif velocity.x > 0: 
				direction = "right"
				Weapon.rotation_degrees = 270
				Weapon.position = Vector2(8, -4)
			elif velocity.y > 0:
				direction = "down"
				Weapon.rotation_degrees = 0
				Weapon.position = Vector2(0, 0)
			elif velocity.y < 0: 
				direction = "up"
				Weapon.rotation_degrees = 180
				Weapon.position = Vector2(0, -16)
		
		animations.play("walk_" + direction)
	
func _input(event):
	if event.is_action_pressed("ui_attack"):
		PlayerVariables.playerCurrentAttack = true
		
	
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
	if area.name == "SlimeHitBox": 
		enemyCollisions.append(area)

func knockBack(enemyVelocity: Vector2):
	var knockBackDirection = (enemyVelocity - velocity).normalized()*knockBackPower
	velocity = knockBackDirection
	move_and_slide()


func _on_hurt_box_area_exited(area):
	enemyCollisions.erase(area)
