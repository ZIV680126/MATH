# Robo-Rumble Arena (זירת קרב הרובוטים)

Robo-Rumble Arena is a fast-paced 3v3 multiplayer mobile arena shooter inspired by Brawl Stars, built with Godot 4 and GDScript. It supports iOS and Android exports, with virtual joystick controls, modular robot loadouts, and online matches. This repository includes one complete game mode (Capture the Core), a demo of a second mode (Resource Rush), two ready maps, three selectable robots, and a basic progression system with coins and upgrades.

## Features
- 3v3 real-time multiplayer using ENet (authoritative host)
- One complete mode: Capture the Core
- Demo of second mode: Resource Rush
- Two maps with dynamic elements (moving obstacles, magnets, low gravity zones)
- Three robot presets and a modular loadout system (Chassis, Weapon, Ability)
- Virtual joystick controls (left: movement; right: fire; dedicated ability button)
- Bots to fill empty slots and a training mode
- Basic progression: coins, upgrades, and unlocks (local save + cloud stub)
- Clean, modular code structure for easy extension

## Tech
- Engine: Godot 4.x (GDScript)
- Networking: ENet via Godot Multiplayer API (authoritative host)
- Platforms: Android and iOS

## Project Structure
```
RoboRumbleArena/
  project.godot
  export_presets.cfg
  Scenes/
    MainMenu.tscn
    Lobby.tscn
    Arena_CaptureTheCore.tscn
    Arena_ResourceRush.tscn
    Robot.tscn
    Projectile.tscn
    UI_HUD.tscn
    UI/VirtualJoystick.tscn
  Scripts/
    network/NetworkManager.gd
    game/GameState.gd
    game/GameMode.gd
    game/CaptureTheCore.gd
    game/ResourceRush.gd
    robot/Robot.gd
    robot/Chassis.gd
    robot/Weapon.gd
    robot/weapons/LaserGun.gd
    robot/weapons/RocketLauncher.gd
    robot/weapons/RapidFireGun.gd
    robot/Ability.gd
    robot/abilities/ShieldAbility.gd
    robot/abilities/TeleportAbility.gd
    robot/abilities/EmpAbility.gd
    robot/BotAI.gd
    ui/VirtualJoystick.gd
    ui/HUD.gd
    systems/UpgradeSystem.gd
    systems/PlayerProfile.gd
    systems/Matchmaker.gd
  Resources/
    Materials/*.tres
```

## Setup
1. Install Godot 4.x (Mono not required).
2. Open this folder (`RoboRumbleArena`) as a project in Godot.
3. Ensure the main scene is `Scenes/MainMenu.tscn`.

## Running Locally
- Host a match: Main Menu → Play → Host (fills with bots up to 3v3)
- Join a match: Main Menu → Play → Join (enter IP)
- Training: Main Menu → Training (spawns bots only, no networking)

## Controls
- Mobile: Virtual joystick on left, fire on right, ability button on the right.
- Desktop: WASD to move, Left mouse to fire, Space for ability.

## Exporting
- Android: Configure Android SDK in Godot Editor, then use `export_presets.cfg`.
- iOS: Configure the iOS export template and signing in Godot Editor.

## Notes
- Networking uses an authoritative host (the host simulates the match and replicates state).
- Resource Rush is provided as a demo: collection and deposit logic included, missing some UI polish.
- Basic persistence is local (`user://profile.save`) with a stub for cloud save (extend `PlayerProfile.gd`).

## License
MIT