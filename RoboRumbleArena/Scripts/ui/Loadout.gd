extends Control

const CHASSIS := ["Scout","Balanced","Bruiser"]
const WEAPONS := ["Laser","Rapid","Rockets"]
const ABILITIES := ["Shield","Teleport","EMP"]

func _ready() -> void:
    var chassis := $VBox/Chassis as OptionButton
    var weapon := $VBox/Weapon as OptionButton
    var ability := $VBox/Ability as OptionButton
    for i in CHASSIS.size(): chassis.add_item(CHASSIS[i], i)
    for i in WEAPONS.size(): weapon.add_item(WEAPONS[i], i)
    for i in ABILITIES.size(): ability.add_item(ABILITIES[i], i)
    chassis.select(_index_of(CHASSIS, Profile.selected_chassis))
    weapon.select(_index_of(WEAPONS, Profile.selected_weapon))
    ability.select(_index_of(ABILITIES, Profile.selected_ability))

func _index_of(arr: Array, value) -> int:
    for i in arr.size():
        if arr[i] == value:
            return i
    return 0

func _on_back_pressed() -> void:
    get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _on_save_pressed() -> void:
    var chassis := $VBox/Chassis as OptionButton
    var weapon := $VBox/Weapon as OptionButton
    var ability := $VBox/Ability as OptionButton
    Profile.selected_chassis = chassis.get_item_text(chassis.get_selected_id())
    Profile.selected_weapon = weapon.get_item_text(weapon.get_selected_id())
    Profile.selected_ability = ability.get_item_text(ability.get_selected_id())
    Profile._save()
    get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")