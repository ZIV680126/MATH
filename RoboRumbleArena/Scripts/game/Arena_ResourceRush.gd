extends Node3D

@export var mode_path: NodePath
@export var red_spawns_path: NodePath
@export var blue_spawns_path: NodePath
@export var robot_scene: PackedScene

var _mode: ResourceRush
var _red_spawns: Node3D
var _blue_spawns: Node3D

func _ready() -> void:
    _mode = get_node_or_null(mode_path)
    _red_spawns = get_node_or_null(red_spawns_path)
    _blue_spawns = get_node_or_null(blue_spawns_path)
    if _mode:
        _mode.start_mode()
    if multiplayer.is_server():
        var peers := [1]
        for id in multiplayer.get_peers():
            if id not in peers:
                peers.append(id)
        for pid in peers:
            _spawn_robot_for_peer(pid)

func _spawn_robot_for_peer(peer_id: int) -> void:
    var team := GameState.assign_player_to_team(peer_id)
    var robot: Robot = robot_scene.instantiate()
    robot.team = team
    robot.set_multiplayer_authority(peer_id, true)
    var loadout := Profile.get_selected_chassis_data()
    var weapon := Profile.instantiate_selected_weapon()
    var ability := Profile.instantiate_selected_ability()
    robot.set_loadout(loadout, weapon, ability)
    var parent_spawns := _red_spawns if team == GameState.TEAM_RED else _blue_spawns
    var idx := randi() % max(1, parent_spawns.get_child_count())
    var sp: Node3D = parent_spawns.get_child(idx)
    robot.global_transform.origin = sp.global_transform.origin
    add_child(robot)