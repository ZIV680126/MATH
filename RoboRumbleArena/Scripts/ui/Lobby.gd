extends Control

func _on_timer_timeout() -> void:
    if NetworkManager.is_server:
        NetworkManager.change_scene_for_all("res://Scenes/Arena_CaptureTheCore.tscn")