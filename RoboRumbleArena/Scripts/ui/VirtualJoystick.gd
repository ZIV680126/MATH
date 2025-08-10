extends Control
class_name VirtualJoystick

signal changed(direction: Vector2)

@export var radius: float = 120.0

var _dragging: bool = false
var _origin: Vector2
var _current: Vector2

func _gui_input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        if event.pressed:
            _dragging = true
            _origin = event.position
            _current = _origin
        else:
            _dragging = false
            _current = _origin
            changed.emit(Vector2.ZERO)
    elif event is InputEventScreenDrag and _dragging:
        _current = event.position
        var dir := (_current - _origin)
        if dir.length() > radius:
            dir = dir.normalized() * radius
        var norm := dir / radius
        changed.emit(Vector2(norm.x, norm.y))