extends Node3D

@onready var camera = get_node("../Camera")
@onready var player = get_node("../ModelPivot")

var rayOrigin = Vector3()
var rayEnd = Vector3()

func _physics_process(delta):
	var space_state = get_world_3d().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	var ray_query = PhysicsRayQueryParameters3D.new()
	

	rayOrigin = camera.project_ray_origin(mouse_position)
	rayEnd = rayOrigin + camera.project_ray_normal(mouse_position) * 2000
	ray_query.from = rayOrigin
	ray_query.to = rayEnd
	ray_query.collide_with_areas = true
	var raycast_result = space_state.intersect_ray(ray_query)

	if not raycast_result.is_empty():
		var pos = raycast_result.position
		get_node("../gizmo").position = Vector3(pos.x, pos.y, 0)
		look_at(Vector3(pos.x, pos.y, 0), Vector3(0,0,1))
		
	if player.global_position.x < raycast_result.position.x:
		player.rotation.y = 0
	else:
		player.rotation.y = deg_to_rad(180)
	print(player.global_position.x , raycast_result.position.x)

