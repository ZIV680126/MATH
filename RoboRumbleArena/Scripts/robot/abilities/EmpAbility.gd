extends Ability
class_name EmpAbility

@export var radius: float = 6.0
@export var stun_time: float = 1.5

func _do_activate(owner_robot: Robot) -> void:
    var space := owner_robot.get_world_3d().direct_space_state
    var shape := SphereShape3D.new()
    shape.radius = radius
    var params := PhysicsShapeQueryParameters3D.new()
    params.shape = shape
    params.transform = Transform3D(Basis(), owner_robot.global_transform.origin)
    params.collision_mask = 1
    var results := space.intersect_shape(params)
    for r in results:
        var collider := r.get("collider")
        if collider and collider is Robot and collider != owner_robot:
            _stun_robot(collider)

func _stun_robot(r: Robot) -> void:
    var original_speed := r.move_speed
    r.move_speed = 0.0
    var t := get_tree().create_timer(stun_time)
    t.timeout.connect(func(): r.move_speed = original_speed)