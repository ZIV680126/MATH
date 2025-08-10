extends Node
class_name GameState

signal match_started(mode_name: String)
signal match_ended(winning_team: int)

const TEAM_RED: int = 1
const TEAM_BLUE: int = 2

var team_scores: Dictionary = {TEAM_RED: 0, TEAM_BLUE: 0}
var team_players: Dictionary = {TEAM_RED: [], TEAM_BLUE: []}
var mode_name: String = ""
var coins_earned_last_match: int = 0

func reset() -> void:
    team_scores = {TEAM_RED: 0, TEAM_BLUE: 0}
    team_players = {TEAM_RED: [], TEAM_BLUE: []}
    mode_name = ""
    coins_earned_last_match = 0

func start_match(_mode_name: String) -> void:
    reset()
    mode_name = _mode_name
    match_started.emit(mode_name)

func end_match(winning_team: int) -> void:
    match_ended.emit(winning_team)
    coins_earned_last_match = 50 if winning_team != 0 else 20
    Profile.add_coins(coins_earned_last_match)

func assign_player_to_team(peer_id: int) -> int:
    var red_count: int = team_players[TEAM_RED].size()
    var blue_count: int = team_players[TEAM_BLUE].size()
    var team: int = TEAM_RED if red_count <= blue_count else TEAM_BLUE
    team_players[team].append(peer_id)
    return team

func get_team_of_player(peer_id: int) -> int:
    for t in team_players.keys():
        if peer_id in team_players[t]:
            return t
    return 0

func add_score(team: int, amount: int) -> void:
    if not team_scores.has(team):
        return
    team_scores[team] += amount