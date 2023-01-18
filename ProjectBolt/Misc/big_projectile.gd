extends Area3D

signal bighit

@export var speed = 50
var velocity = Vector3.ZERO


func _physics_process(delta):
	look_at(transform.origin + velocity.normalized(), Vector3.UP)
	transform.origin +=  velocity * delta


func _on_body_entered(body):
	emit_signal("bighit",  transform.origin)
	queue_free()
