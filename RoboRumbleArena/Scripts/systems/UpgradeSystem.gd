extends Node
class_name UpgradeSystem

const MAX_LEVEL: int = 10

func get_upgrade_cost(level: int) -> int:
    return 20 + level * 10

func apply_chassis_upgrade(chassis: Dictionary, level: int) -> Dictionary:
    var upgraded := chassis.duplicate(true)
    upgraded.speed *= 1.0 + level * 0.03
    upgraded.health *= 1.0 + level * 0.05
    return upgraded

func apply_weapon_upgrade(base_damage: float, level: int) -> float:
    return base_damage * (1.0 + level * 0.04)