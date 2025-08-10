extends Control
class_name HUD

@export var move_joystick_path: NodePath = NodePath("MoveJoystick")
@export var fire_button_path: NodePath = NodePath("Fire")
@export var ability_button_path: NodePath = NodePath("Ability")

var _move_dir: Vector2 = Vector2.ZERO
var _aim_dir: Vector3 = Vector3.FORWARD
var _fire_pressed: bool = false
var _ability_pressed: bool = false
var _robot: Robot

func _ready() -> void:
    var move_joy: Control = get_node_or_null(move_joystick_path)
    if move_joy and move_joy.has_signal("changed"):
        move_joy.connect("changed", Callable(self, "_on_move_changed"))
    var fire_btn: BaseButton = get_node_or_null(fire_button_path)
    if fire_btn:
        fire_btn.pressed.connect(func(): _fire_pressed = true)
        fire_btn.button_up.connect(func(): _fire_pressed = false)
    var ability_btn: BaseButton = get_node_or_null(ability_button_path)
    if ability_btn:
        ability_btn.pressed.connect(func(): _ability_pressed = true)
        ability_btn.button_up.connect(func(): _ability_pressed = false)

func set_robot(r: Robot) -> void:
    _robot = r

func _process(delta: float) -> void:
    if _robot == null:
        return
    var cam := get_viewport().get_camera_3d()
    var forward := cam.global_transform.basis.z * -1.0 if cam else Vector3.FORWARD
    var aim := (forward).normalized()
    _aim_dir = aim
    if _robot.has_method("send_input"):
        _robot.send_input.rpc(_move_dir, _aim_dir, _fire_pressed, _ability_pressed)
    _ability_pressed = false

func _on_move_changed(dir: Vector2) -> void:
    _move_dir = dir