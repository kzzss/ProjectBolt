extends CharacterBody3D


@export var move_speed = 7.0
@export var jump_strength = 5
@export var thrust_strength = 16
@export var fuel = 60
@export var acceleration = 100.0
@export var friction = 100.0

@onready var smallProjectile = preload("res://Misc/small_projectile.tscn")
@onready var bigProjectile = preload("res://Misc/big_projectile.tscn")

var chargeStatus = 0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		$ChargeTimer.start()
		var sp = smallProjectile.instantiate()
		owner.add_child(sp)
		sp.transform = $WeaponPivot/ProjectileSpawn.global_transform
		sp.velocity = -sp.transform.basis.z * sp.speed

	if Input.is_action_just_released("shoot"):
		$ChargeTimer.stop()
	if Input.is_action_just_released("shoot") and chargeStatus == 1:
		$ChargeUpTimer.stop()
		print("CHARGING CANCELED")
		chargeStatus = 0
	if Input.is_action_just_released("shoot") and chargeStatus == 2:
		print("CHARGEBEAM FIRED")
		var bp = bigProjectile.instantiate()
		owner.add_child(bp)
		bp.transform = $WeaponPivot/ProjectileSpawn.global_transform
		bp.velocity = -bp.transform.basis.z * bp.speed
		
		chargeStatus = 0
		
		

func _physics_process(delta):

	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if is_on_floor() and fuel < 60:
		fuel_reset()


	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_strength
		
	if Input.is_action_pressed("thrust") and fuel > 0:
		velocity.y += thrust_strength * delta
		fuel -= 1
		
	
	
	var input_vector = 0
	input_vector =Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if input_vector != 0:
		velocity = Vector3(move_toward(velocity.x, input_vector * move_speed, acceleration * delta),velocity.y, velocity.z)
	else:
		velocity = Vector3(move_toward(velocity.x, 0, friction * delta),velocity.y, velocity.z)

	move_and_slide()
	
func fuel_reset():
		fuel = fuel + 2


func _on_charge_timer_timeout():
	print("CHARGING...")
	$ChargeUpTimer.start()
	chargeStatus = 1


func _on_charge_up_timer_timeout():
	print("CHARGEBEAM READY")
	chargeStatus = 2

