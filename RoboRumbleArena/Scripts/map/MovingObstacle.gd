extends Node3D
class_name MovingObstacle

@export var amplitude: float = 3.0
@export var speed: float = 1.0
@export var axis: Vector3 = Vector3(1,0,0)

var _t: float = 0.0
var _origin: Vector3

func _ready() -> void:
    _origin = global_transform.origin

func _process(delta: float) -> void:
    _t += delta * speed
    var offset := sin(_t) * amplitude
    global_transform.origin = _origin + axis.normalized() * offset