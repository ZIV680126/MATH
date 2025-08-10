extends Node
class_name PlayerProfile

signal profile_changed

var coins: int = 0
var unlocked_chassis: Array = []
var unlocked_weapons: Array = []
var unlocked_abilities: Array = []
var chassis_upgrades: Dictionary = {}
var weapon_upgrades: Dictionary = {}
var ability_upgrades: Dictionary = {}

var selected_chassis: String = "Scout"
var selected_weapon: String = "Laser"
var selected_ability: String = "Shield"

const SAVE_PATH := "user://profile.save"

func _ready() -> void:
    _load()
    if unlocked_chassis.is_empty():
        unlocked_chassis = ["Scout", "Bruiser", "Balanced"]
        unlocked_weapons = ["Laser", "Rockets", "Rapid"]
        unlocked_abilities = ["Shield", "Teleport", "EMP"]
        _save()

func add_coins(amount: int) -> void:
    coins += amount
    _save()
    profile_changed.emit()

func spend_coins(amount: int) -> bool:
    if coins < amount:
        return false
    coins -= amount
    _save()
    profile_changed.emit()
    return true

func get_selected_chassis_data() -> Dictionary:
    match selected_chassis:
        "Scout":
            return {"name":"Scout","speed":10.0,"health":80.0}
        "Bruiser":
            return {"name":"Bruiser","speed":7.0,"health":130.0}
        _:
            return {"name":"Balanced","speed":8.5,"health":100.0}

func instantiate_selected_weapon() -> Weapon:
    var w: Weapon
    match selected_weapon:
        "Laser":
            w = LaserGun.new()
            w.name = "Laser"
            w.damage = 18.0
            w.cooldown = 0.4
        "Rockets":
            w = RocketLauncher.new()
            w.name = "Rockets"
            w.damage = 30.0
            w.cooldown = 1.0
            w.projectile_scene = load("res://Scenes/Projectile.tscn")
        _:
            w = RapidFireGun.new()
            w.name = "Rapid"
            w.damage = 7.0
            w.cooldown = 0.12
    return w

func instantiate_selected_ability() -> Ability:
    var a: Ability
    match selected_ability:
        "Shield":
            a = ShieldAbility.new()
        "Teleport":
            a = TeleportAbility.new()
        _:
            a = EmpAbility.new()
    return a

func _save() -> void:
    var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    var data := {
        "coins": coins,
        "unlocked_chassis": unlocked_chassis,
        "unlocked_weapons": unlocked_weapons,
        "unlocked_abilities": unlocked_abilities,
        "chassis_upgrades": chassis_upgrades,
        "weapon_upgrades": weapon_upgrades,
        "ability_upgrades": ability_upgrades,
        "selected_chassis": selected_chassis,
        "selected_weapon": selected_weapon,
        "selected_ability": selected_ability
    }
    f.store_string(JSON.stringify(data))

func _load() -> void:
    if not FileAccess.file_exists(SAVE_PATH):
        return
    var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
    var s := f.get_as_text()
    var parsed := JSON.parse_string(s)
    if typeof(parsed) == TYPE_DICTIONARY:
        coins = parsed.get("coins", 0)
        unlocked_chassis = parsed.get("unlocked_chassis", [])
        unlocked_weapons = parsed.get("unlocked_weapons", [])
        unlocked_abilities = parsed.get("unlocked_abilities", [])
        chassis_upgrades = parsed.get("chassis_upgrades", {})
        weapon_upgrades = parsed.get("weapon_upgrades", {})
        ability_upgrades = parsed.get("ability_upgrades", {})
        selected_chassis = parsed.get("selected_chassis", selected_chassis)
        selected_weapon = parsed.get("selected_weapon", selected_weapon)
        selected_ability = parsed.get("selected_ability", selected_ability)

func save_to_cloud_stub() -> void:
    # Extend this method to push profile to your backend
    pass