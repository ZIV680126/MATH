extends Area3D

@export var velocity: Vector3 = Vector3.ZERO
@export var damage: float = 20.0
var owner_peer: int = 0

func _ready() -> void:
    body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
    global_transform.origin += velocity * delta

func _on_body_entered(body: Node) -> void:
    if body is Robot:
        body.apply_damage(damage, owner_peer)
    queue_free()