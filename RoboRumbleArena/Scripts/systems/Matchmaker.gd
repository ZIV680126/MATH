extends Node
class_name Matchmaker

@export var fill_with_bots: bool = true

func quick_play_host() -> void:
    NetworkManager.host()
    await NetworkManager.network_ready
    NetworkManager.change_scene_for_all("res://Scenes/Lobby.tscn")

func quick_play_join(ip: String) -> void:
    NetworkManager.join(ip)
    await NetworkManager.network_ready