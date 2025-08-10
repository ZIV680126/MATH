extends Area3D
class_name MagnetArea

@export var pull_strength: float = 6.0
var _bodies: Array = []

func _ready() -> void:
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)

func _physics_process(delta: float) -> void:
    for b in _bodies:
        if b and b is Robot:
            var dir := (global_transform.origin - b.global_transform.origin)
            if dir.length() > 0.01:
                b.global_transform.origin += dir.normalized() * pull_strength * delta

func _on_body_entered(body: Node) -> void:
    if body not in _bodies:
        _bodies.append(body)

func _on_body_exited(body: Node) -> void:
    _bodies.erase(body)