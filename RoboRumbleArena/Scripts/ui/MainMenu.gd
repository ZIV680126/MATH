extends Control

func _on_host_pressed() -> void:
    NetworkManager.host()
    get_tree().change_scene_to_file("res://Scenes/Lobby.tscn")

func _on_join_pressed() -> void:
    var ip := $VBox/IP.text
    NetworkManager.join(ip)

func _on_training_pressed() -> void:
    get_tree().change_scene_to_file("res://Scenes/Arena_CaptureTheCore.tscn")

func _on_loadout_pressed() -> void:
    get_tree().change_scene_to_file("res://Scenes/Loadout.tscn")