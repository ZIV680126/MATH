extends Node
class_name Ability

@export var name: String = "Ability"
@export var cooldown: float = 8.0

var _cooldown_left: float = 0.0

func _process(delta: float) -> void:
    if _cooldown_left > 0.0:
        _cooldown_left = max(0.0, _cooldown_left - delta)

func can_activate() -> bool:
    return _cooldown_left <= 0.0

func activate(owner_robot: Robot) -> void:
    if not can_activate():
        return
    _cooldown_left = cooldown
    _do_activate(owner_robot)

func _do_activate(owner_robot: Robot) -> void:
    pass