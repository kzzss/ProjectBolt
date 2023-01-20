extends CharacterBody3D

signal dead

@export var health = 4

func _process(delta):
	if health <= 0:
		death()
		

func _on_hurtbox_area_entered(area):
	health -= 1

func death():
	emit_signal("dead")
	queue_free()
