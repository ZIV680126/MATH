extends Ability
class_name ShieldAbility

@export var duration: float = 3.0
@export var damage_multiplier: float = 0.5

func _do_activate(owner_robot: Robot) -> void:
    var original_apply_damage := owner_robot.apply_damage
    func reduced_damage(damage: float, from_peer: int) -> void:
        original_apply_damage.call(damage * damage_multiplier, from_peer)
    owner_robot.apply_damage = reduced_damage
    var t := get_tree().create_timer(duration)
    t.timeout.connect(func(): owner_robot.apply_damage = original_apply_damage)