extends Area3D

signal hit

@export var speed = 25
var velocity = Vector3.ZERO


func _physics_process(delta):
	look_at(transform.origin + velocity.normalized(), Vector3.UP)
	transform.origin +=  velocity * delta


func _on_body_entered(body):
	emit_signal("hit",  transform.origin)
	queue_free()
