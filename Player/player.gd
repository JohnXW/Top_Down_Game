extends CharacterBody2D

class_name Player

signal healthChange
signal attacked
@export var speed: int = 60
@onready var animations = $AnimationPlayer
@onready var hurtBox = $HurtBox
@onready var hurtEffect = $HitEffect
@onready var HurtTimer = $HurtTimer
@onready var AttackTImer = $AttackTimer
@onready var weapon = $Weapons
@onready var weaponCollision = weapon.get_child(1)
@export var knockBackPower:int = 200
#@onready var currentHP: int = PlayerVariables.currentHP
var playerHurt:bool = false
var movedirection
var direction = "down"
var playerAttackingInProgress:bool = false


func _ready():
	hurtEffect.play("RESET")
	weapon.visible = false

func handleInput():
	movedirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if playerAttackingInProgress == true:
		velocity = Vector2.ZERO
	else:
		velocity = movedirection * speed

func updateAnimation(): 
	if playerAttackingInProgress == false:
		if velocity.length() == 0:
			animations.stop()
		
		else:
			if velocity.x < 0: 
				direction = "left"
				weapon.rotation_degrees = 90
				weapon.position = Vector2(-8, -4)
			elif velocity.x > 0: 
				direction = "right"
				weapon.rotation_degrees = 270
				weapon.position = Vector2(8, -4)
			elif velocity.y > 0:
				direction = "down"
				weapon.rotation_degrees = 0
				weapon.position = Vector2(0, 0)
			elif velocity.y < 0: 
				direction = "up"
				weapon.rotation_degrees = 180
				weapon.position = Vector2(0, -16)
		
		animations.play("walk_" + direction)
	
func _input(event):
	if playerAttackingInProgress != true:
		if event.is_action_pressed("ui_attack"):
			weaponCollision.disabled = false
			PlayerVariables.playerCurrentAttack = true
			playerAttackingInProgress = true
			animations.play("attack_" + direction)
			AttackTImer.start()
			await AttackTImer.timeout
			weaponCollision.disabled = true
		
	
func _physics_process(delta):
	handleInput()
	move_and_slide()
	updateAnimation()
	if !playerHurt: # loops when player is not being damaged
		for area in hurtBox.get_overlapping_areas(): # calls hurtByEnemy if there r enemies inside players hitbox
			if area.name == "SlimeHitBox":
				hurtByEnemy(area)

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


func knockBack(enemyVelocity: Vector2):
	var knockBackDirection = (enemyVelocity - velocity).normalized()*knockBackPower
	velocity = knockBackDirection
	move_and_slide()


func _on_animation_player_animation_started(anim_name):
	if anim_name == ("attack_" + direction):
		weapon.visible = true

func _on_animation_player_animation_finished(anim_name):
	if anim_name == ("attack_" + direction):
		weapon.visible = false
		PlayerVariables.playerCurrentAttack = false
		playerAttackingInProgress = false
#		weaponCollision.disabled = true
#		attacked.emit(false)


func _on_hurt_box_area_entered(area):
	if area.has_method("collect"):
		area.collect()


func _on_hurt_box_area_exited(area):
	pass # Replace with function body.
