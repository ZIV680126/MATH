extends GameMode
class_name ResourceRush

@export var resources_in_world: Array[NodePath]
@export var base_red_path: NodePath
@export var base_blue_path: NodePath
@export var deposit_amount: int = 5

var _bases: Dictionary

func start_mode() -> void:
    super.start_mode()
    _bases = {
        GameState.TEAM_RED: get_node_or_null(base_red_path),
        GameState.TEAM_BLUE: get_node_or_null(base_blue_path)
    }
    objective_updated.emit("Collect parts and deposit at your base!")

func on_robot_eliminated(robot: Node, killer: Node) -> void:
    # Demo: Drop a resource on elimination
    if not is_running:
        return
    # In a full implementation, spawn a pickup where the robot was eliminated
    pass

func on_robot_deposit(peer_id: int) -> void:
    var team := GameState.get_team_of_player(peer_id)
    if team == 0:
        return
    GameState.add_score(team, deposit_amount)
    objective_updated.emit("Red %d - %d Blue" % [GameState.team_scores[GameState.TEAM_RED], GameState.team_scores[GameState.TEAM_BLUE]])