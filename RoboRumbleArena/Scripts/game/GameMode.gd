extends Node
class_name GameMode

signal objective_updated(text: String)
signal match_over(winning_team: int)

var is_running: bool = false

func start_mode() -> void:
    is_running = true

func stop_mode() -> void:
    is_running = false

func on_robot_spawned(robot: Node) -> void:
    pass

func on_robot_eliminated(robot: Node, killer: Node) -> void:
    pass