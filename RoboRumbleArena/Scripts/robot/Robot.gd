extends CharacterBody3D
class_name Robot

signal eliminated(killer_peer_id: int)
signal fired
signal ability_used

@export var move_speed: float = 8.0
@export var max_health: float = 100.0
@export var team: int = 0
@export var robot_name: String = ""

var current_health: float = 100.0
var weapon: Weapon
var ability: Ability
var is_bot: bool = false

var _input_dir: Vector2 = Vector2.ZERO
var _aim_dir: Vector3 = Vector3.FORWARD

func _ready() -> void:
    current_health = max_health

func set_loadout(chassis_data: Dictionary, weapon_node: Weapon, ability_node: Ability) -> void:
    move_speed = chassis_data.get("speed", move_speed)
    max_health = chassis_data.get("health", max_health)
    current_health = max_health
    weapon = weapon_node
    ability = ability_node

func _physics_process(delta: float) -> void:
    if is_on_floor():
        velocity.y = 0
    velocity.x = _input_dir.x * move_speed
    velocity.z = _input_dir.y * move_speed
    move_and_slide()

func apply_damage(damage: float, from_peer: int) -> void:
    current_health -= damage
    if current_health <= 0:
        eliminated.emit(from_peer)
        queue_free()

@rpc("any_peer", "unreliable_ordered")
func send_input(direction: Vector2, aim: Vector3, fire_pressed: bool, ability_pressed: bool) -> void:
    if multiplayer.is_server():
        _input_dir = direction
        _aim_dir = aim
        if fire_pressed:
            _server_fire()
        if ability_pressed:
            _server_use_ability()

func _server_fire() -> void:
    if weapon:
        weapon.fire(self, _aim_dir)
        fired.emit()

func _server_use_ability() -> void:
    if ability:
        ability.activate(self)
        ability_used.emit()