extends Ability
class_name TeleportAbility

@export var distance: float = 6.0

func _do_activate(owner_robot: Robot) -> void:
    var forward: Vector3 = owner_robot.transform.basis.z * -1.0
    owner_robot.global_transform.origin += forward.normalized() * distance