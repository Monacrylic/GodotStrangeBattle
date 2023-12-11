extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Lightball stuff
const LIGHTBALL = preload("res://scenes/lighball.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var P2_SHIELD = preload("res://scenes/p2_shield.tscn")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		
	

	move_and_slide()
	if (Input.is_action_just_pressed("p2_defend")):
		player2_defend(true)
		
	if(Input.is_action_just_pressed("p2_attack")):
		player2_attack()
		
	if ($Sprite2D.is_playing() == false):
		$Sprite2D.animation="default"
		$Sprite2D.play("default")
		
func injury():
	$Sprite2D.play("hurt")
	get_tree().get_root().get_node("Node").mqtt_injurePlayer(2, 5)
	
func player2_attack():
	$Sprite2D.animation = "attackSpell"
	var lightball = LIGHTBALL.instantiate()
	get_parent().add_child(lightball)
	lightball.position = $Marker2D.global_position
	
func player2_defend(status):
	$Sprite2D.play("deployShield")
	var p2_shield = P2_SHIELD.instantiate()
	get_parent().add_child(p2_shield)
	p2_shield.position = $Marker2D.global_position
	
