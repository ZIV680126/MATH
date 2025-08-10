extends Weapon
class_name RocketLauncher

@export var projectile_scene: PackedScene
@export var speed: float = 25.0

func _do_fire(owner_robot: Node, aim_dir: Vector3) -> void:
    if projectile_scene == null:
        return
    var projectile := projectile_scene.instantiate()
    projectile.global_transform.origin = owner_robot.global_transform.origin + aim_dir.normalized() * 1.2
    projectile.velocity = aim_dir.normalized() * speed
    projectile.damage = damage
    projectile.owner_peer = owner_robot.get_multiplayer_authority()
    owner_robot.get_tree().current_scene.add_child(projectile)