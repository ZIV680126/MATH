extends GameMode
class_name CaptureTheCore

@export var core_node_path: NodePath
@export var score_per_tick: int = 1
@export var tick_interval: float = 1.0

var _core: Node3D
var _time_accumulator: float = 0.0
var _holder_peer_id: int = 0

func start_mode() -> void:
    super.start_mode()
    _core = get_node_or_null(core_node_path)
    objective_updated.emit("Hold the Core to earn points!")

func _process(delta: float) -> void:
    if not is_running:
        return
    _time_accumulator += delta
    if _time_accumulator >= tick_interval:
        _time_accumulator = 0.0
        if _holder_peer_id != 0:
            var team := GameState.get_team_of_player(_holder_peer_id)
            if team != 0:
                GameState.add_score(team, score_per_tick)
                objective_updated.emit("Red %d - %d Blue" % [GameState.team_scores[GameState.TEAM_RED], GameState.team_scores[GameState.TEAM_BLUE]])
                var winning: int = _check_win_condition()
                if winning != 0:
                    match_over.emit(winning)
                    GameState.end_match(winning)
                    stop_mode()

func set_holder(peer_id: int) -> void:
    _holder_peer_id = peer_id

func _check_win_condition() -> int:
    if GameState.team_scores[GameState.TEAM_RED] >= 100:
        return GameState.TEAM_RED
    if GameState.team_scores[GameState.TEAM_BLUE] >= 100:
        return GameState.TEAM_BLUE
    return 0