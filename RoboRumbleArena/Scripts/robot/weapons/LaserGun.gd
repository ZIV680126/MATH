extends Weapon
class_name LaserGun

@export var range: float = 40.0

func _do_fire(owner_robot: Node, aim_dir: Vector3) -> void:
    var from: Vector3 = owner_robot.global_transform.origin
    var to: Vector3 = from + aim_dir.normalized() * range
    var space := owner_robot.get_world_3d().direct_space_state
    var query := PhysicsRayQueryParameters3D.create(from, to)
    query.collision_mask = 1
    var result := space.intersect_ray(query)
    if result and result.has("collider"):
        if result.collider and result.collider is Robot:
            result.collider.apply_damage(damage, owner_robot.get_multiplayer_authority())