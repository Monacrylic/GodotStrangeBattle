extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var sprite2D = $Sprite2D
const FIREBALL = preload("res://scenes/fireball.tscn")

var P1_SHIELD = preload("res://scenes/p1_shield.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Shield Status
var p1_shield_status = false


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		#sprite2D.animation = "attackSpell"

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	var isLeft = velocity.x <0
	sprite2D.flip_h = isLeft
	
	
	# Defence shield:
	if (Input.is_action_just_pressed("p1_defend")):
		player1_defend(true)

	elif(Input.is_action_just_pressed("p1_attack")):
		player1_attack()
		
	# Continue playing sprite Idle animation
	if (sprite2D.is_playing() == false):
		sprite2D.animation="default"
		sprite2D.play("default")

func player1_attack():
	sprite2D.animation = "attackSpell"
	var fireball = FIREBALL.instantiate()
	get_parent().add_child(fireball)
	fireball.position = $Marker2D.global_position

func player1_defend(new_shield_state):
	#if(new_shield_state == true and p1_shield_status == false):
	$Sprite2D.play("deployShield")
	var p1_shield = P1_SHIELD.instantiate()
	get_parent().add_child(p1_shield)
	p1_shield.position = $Marker2D.global_position
	p1_shield_status = true
	#elif(new_shield_state == false):
		##Destroy the p1_shield child that was made above
		#if $P1_SHIELD != null:  # Check if the p1_shield exists
			#$P1_SHIELD.destroy()  # Destroy the p1_shield node
			#p1_shield_status = false

func injury():
	$Sprite2D.play("hurt")
	get_tree().get_root().get_node("Node").mqtt_injurePlayer(1, 5)
	
