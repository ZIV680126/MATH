extends Node
class_name NetworkManager

const DEFAULT_PORT: int = 43210
const MAX_CLIENTS: int = 12

signal network_ready
signal server_started
signal server_stopped
signal client_connected(peer_id: int)
signal client_disconnected(peer_id: int)

var is_server: bool = false
var is_connected: bool = false

func _ready() -> void:
    multiplayer.peer_connected.connect(_on_peer_connected)
    multiplayer.peer_disconnected.connect(_on_peer_disconnected)
    multiplayer.connected_to_server.connect(_on_connected_to_server)
    multiplayer.connection_failed.connect(_on_connection_failed)
    multiplayer.server_disconnected.connect(_on_server_disconnected)

func host(port: int = DEFAULT_PORT, max_clients: int = MAX_CLIENTS) -> void:
    var peer := ENetMultiplayerPeer.new()
    var err := peer.create_server(port, max_clients)
    if err != OK:
        push_error("Failed to create server: %s" % err)
        return
    multiplayer.multiplayer_peer = peer
    is_server = true
    is_connected = true
    server_started.emit()
    network_ready.emit()

func join(address: String, port: int = DEFAULT_PORT) -> void:
    var peer := ENetMultiplayerPeer.new()
    var err := peer.create_client(address, port)
    if err != OK:
        push_error("Failed to connect: %s" % err)
        return
    multiplayer.multiplayer_peer = peer

func disconnect() -> void:
    if multiplayer.multiplayer_peer:
        multiplayer.multiplayer_peer.close()
    is_server = false
    is_connected = false
    server_stopped.emit()

func change_scene_for_all(scene_path: String) -> void:
    if not is_server:
        return
    _rpc_change_scene.rpc(scene_path)

@rpc("authority")
func _rpc_change_scene(scene_path: String) -> void:
    var err := get_tree().change_scene_to_file(scene_path)
    if err != OK:
        push_error("Scene change failed: %s" % err)

func _on_peer_connected(id: int) -> void:
    client_connected.emit(id)

func _on_peer_disconnected(id: int) -> void:
    client_disconnected.emit(id)

func _on_connected_to_server() -> void:
    is_connected = true
    network_ready.emit()

func _on_connection_failed() -> void:
    is_connected = false

func _on_server_disconnected() -> void:
    is_connected = false
    is_server = false