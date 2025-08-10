extends Node
class_name BotAI

@export var robot_path: NodePath
@export var target_core_path: NodePath

var robot: Robot
var target_core: Node3D
var _rng := RandomNumberGenerator.new()

func _ready() -> void:
    robot = get_node_or_null(robot_path)
    target_core = get_node_or_null(target_core_path)
    _rng.randomize()
    set_process(true)

func _process(delta: float) -> void:
    if not robot:
        return
    var dir := Vector3.ZERO
    if target_core:
        var to_core := (target_core.global_transform.origin - robot.global_transform.origin)
        dir = to_core.normalized()
    else:
        dir = Vector3(_rng.randf_range(-1,1),0,_rng.randf_range(-1,1)).normalized()
    var move2 := Vector2(dir.x, dir.z)
    var aim := dir
    if multiplayer.is_server() and robot.has_method("send_input"):
        robot.send_input(move2, aim, _rng.randf() < 0.02, _rng.randf() < 0.01)