extends Node
class_name Weapon

@export var name: String = "Weapon"
@export var damage: float = 10.0
@export var cooldown: float = 0.3

var _cooldown_left: float = 0.0

func _process(delta: float) -> void:
    if _cooldown_left > 0.0:
        _cooldown_left = max(0.0, _cooldown_left - delta)

func can_fire() -> bool:
    return _cooldown_left <= 0.0

func fire(owner_robot: Node, aim_dir: Vector3) -> void:
    if not can_fire():
        return
    _cooldown_left = cooldown
    _do_fire(owner_robot, aim_dir)

func _do_fire(owner_robot: Node, aim_dir: Vector3) -> void:
    pass