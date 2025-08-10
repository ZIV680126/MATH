extends Node3D

@export var capture_mode_path: NodePath
@export var core_area_path: NodePath
@export var red_spawns_path: NodePath
@export var blue_spawns_path: NodePath
@export var robot_scene: PackedScene
@export var hud_scene: PackedScene

var _capture: CaptureTheCore
var _core_area: Area3D
var _red_spawns: Node3D
var _blue_spawns: Node3D
var _spawned_by_peer: Dictionary = {}

func _ready() -> void:
    _capture = get_node_or_null(capture_mode_path)
    _core_area = get_node_or_null(core_area_path)
    _red_spawns = get_node_or_null(red_spawns_path)
    _blue_spawns = get_node_or_null(blue_spawns_path)

    if _core_area:
        _core_area.body_entered.connect(_on_body_entered_core)
    if _capture:
        _capture.start_mode()

    if multiplayer.is_server():
        # Assign teams and spawn for all peers (including 1 for offline)
        var peers := [1]
        for id in multiplayer.get_peers():
            if id not in peers:
                peers.append(id)
        for pid in peers:
            _spawn_robot_for_peer(pid)
        # Fill with bots up to 6
        while _spawned_by_peer.size() < 6:
            _spawn_bot()
    else:
        # Client waits for server to spawn their robot, HUD will be set via deferred
        pass

func _spawn_bot() -> void:
    var bot := _create_robot_instance(0)
    bot.is_bot = true
    var ai := BotAI.new()
    ai.robot_path = bot.get_path()
    ai.target_core_path = get_node(core_area_path).get_path() if core_area_path != NodePath("") else NodePath("")
    bot.add_child(ai)

func _spawn_robot_for_peer(peer_id: int) -> void:
    var team := GameState.assign_player_to_team(peer_id)
    var robot := _create_robot_instance(peer_id, team)
    _spawned_by_peer[peer_id] = robot
    if peer_id == multiplayer.get_unique_id() or (not multiplayer.has_multiplayer_peer() and peer_id == 1):
        _setup_local_hud(robot)

func _create_robot_instance(peer_id: int, team: int = 0) -> Robot:
    var robot: Robot = robot_scene.instantiate()
    robot.team = team if team != 0 else (GameState.TEAM_RED if randi() % 2 == 0 else GameState.TEAM_BLUE)
    robot.set_multiplayer_authority(peer_id, true)
    var loadout := Profile.get_selected_chassis_data()
    var weapon := Profile.instantiate_selected_weapon()
    var ability := Profile.instantiate_selected_ability()
    robot.set_loadout(loadout, weapon, ability)
    # Choose spawn point
    var parent_spawns := _red_spawns if robot.team == GameState.TEAM_RED else _blue_spawns
    var idx := _spawned_by_peer.size() % max(1, parent_spawns.get_child_count())
    var sp: Node3D = parent_spawns.get_child(idx)
    robot.global_transform.origin = sp.global_transform.origin
    add_child(robot)
    return robot

func _setup_local_hud(robot: Robot) -> void:
    if hud_scene:
        var hud := hud_scene.instantiate()
        add_child(hud)
        hud.set_robot(robot)

func _on_body_entered_core(body: Node) -> void:
    if body is Robot:
        var pid := body.get_multiplayer_authority()
        _capture.set_holder(pid)