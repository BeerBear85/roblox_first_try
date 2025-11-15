# Monster Fighting Game - First Level

A single-player survival game where you fight zombies spawning from a giant spider web using different weapons!

## Game Features

### Player Systems
- **Health System**: 100 HP with visible health bar UI
- **Weapon Arsenal**: 3 different weapons
  - Normal Sword (20 damage, medium speed)
  - Knife (15 damage, fast attacks)
  - Fire Sword (35 damage, slow but powerful)
- **Weapon Switching**: Press 1, 2, or 3 to switch weapons

### Enemies
- **Zombies**: 4 zombies spawn after 60 seconds
  - 50 HP each
  - Overhead health bars
  - Chase and attack AI
  - Deal 10 damage per attack

### Environment
- Forest-themed terrain (to be created in Roblox Studio)
- Giant spider web spawn point (automatically generated)
- Zombies emerge from the spider web area

### Win Condition
- Defeat all zombies to win
- Receive "Survivor's Badge" reward message

## Quick Start

See **[SETUP_GUIDE.md](SETUP_GUIDE.md)** for detailed installation instructions.

**TLDR:**
1. Install Rojo: `cargo install rojo` or download from https://rojo.space
2. Install Rojo plugin in Roblox Studio
3. Run `rojo serve` in this directory
4. Click "Connect" in Roblox Studio
5. Play!

## Development Workflow

This project uses **Rojo** for automatic code synchronization between your editor and Roblox Studio.

### Setting Up Your Development Environment

1. **Install Rojo CLI**
   ```bash
   cargo install rojo
   # OR download from https://github.com/rojo-rbx/rojo/releases
   ```

2. **Install Rojo Studio Plugin**
   - Visit: https://www.roblox.com/library/13916111004/Rojo-7
   - Click Install in Roblox Studio

3. **Project Configuration**
   - The `default.project.json` file maps your source code to Roblox Studio
   - Source structure:
     - `src/Modules/` → `ReplicatedStorage.Modules`
     - `src/ServerScripts/` → `ServerScriptService`
     - `src/ClientScripts/` → `StarterPlayer.StarterPlayerScripts`

### Daily Workflow

**Starting a session:**
```bash
# Navigate to project directory
cd C:\repositories\roblox_first_try

# Start Rojo server
rojo serve
```

**In Roblox Studio:**
1. Open your place file (`game/MonsterFightingGame.rbxl`)
2. Click **Rojo** button in toolbar
3. Click **Connect** (server should auto-detect at port 34872)
4. Click **Sync In** to load your code

**While coding:**
1. Edit files in VS Code (or your preferred editor)
2. Save the file (Ctrl+S)
3. Changes instantly appear in Roblox Studio
4. Test in Roblox Studio by pressing Play

**Tips:**
- Keep `rojo serve` running while developing
- Rojo watches for file changes automatically
- No need to manually copy code anymore!
- Use VS Code extension "Rojo" for better integration

### Manual Setup (Without Rojo)

If you prefer manual setup, see the "Method 2" section in [SETUP_GUIDE.md](SETUP_GUIDE.md#method-2-manual-setup-fallback).

### Creating the Environment

1. **Create Terrain**:
   - Use the Terrain Editor (Home > Editor > Terrain Editor)
   - Generate a forest with grass, trees, and hills
   - Or use a simple grass baseplate for quick testing

2. **Set Spawn Location** (Optional):
   - The default spawn should be at (0, 5, 0)
   - The spider web will spawn at (0, 5, 50) - 50 studs in front
   - You can adjust these positions in the GameManager script

3. **Lighting** (Optional for atmosphere):
   - Set Lighting.TimeOfDay to "18:00:00" for dusk
   - Add Lighting.Atmosphere for fog effects
   - Lighting.FogEnd = 500 for mysterious forest vibe

### Testing the Game

1. Click the "Play" button in Roblox Studio
2. You should see:
   - Your health bar at the bottom
   - Current weapon indicator
   - Timer countdown at the top (60 seconds)
   - A sword in your hand

3. After 60 seconds:
   - 4 zombies will spawn around the spider web
   - They will chase and attack you
   - Fight them using your weapons (click to attack)
   - Switch weapons with 1, 2, 3 keys

4. Win Condition:
   - Defeat all zombies
   - Victory screen appears

## Controls

- **WASD** - Move
- **Space** - Jump
- **Mouse Click** - Attack with current weapon
- **1** - Equip Normal Sword
- **2** - Equip Knife
- **3** - Equip Fire Sword

## Game Balance

### Current Settings (in GameConfig.lua)

| Setting | Value | Notes |
|---------|-------|-------|
| Player Health | 100 HP | Can survive 10 zombie hits |
| Zombie Count | 4 | Easy difficulty |
| Zombie Health | 50 HP | 2-3 hits with sword |
| Zombie Damage | 10 HP | 10 attacks to kill player |
| Spawn Delay | 60 seconds | Time to prepare |
| Sword Damage | 20 HP | 3 hits to kill zombie |
| Knife Damage | 15 HP | 4 hits, but faster |
| Fire Sword Damage | 35 HP | 2 hits, but slower |

### Difficulty Tuning

To make the game **easier**:
- Reduce `ZombieCount` to 3
- Reduce `Zombie.Damage` to 5
- Increase weapon damage values

To make it **harder**:
- Increase `ZombieCount` to 6-8
- Increase `Zombie.Damage` to 15
- Reduce weapon damage
- Reduce `SpawnDelay` to 30 seconds

## Troubleshooting

### Scripts Not Running
- Check Output window for errors
- Ensure all scripts are in the correct locations
- Make sure ModuleScripts are in ReplicatedStorage
- Verify RemoteEvents folder exists in ReplicatedStorage

### Weapons Not Working
- Check that WeaponSetup script is running
- Verify CombatSystem is active
- Make sure player character has spawned

### Zombies Not Spawning
- Check GameManager is running
- Look for "SpiderWebSpawn" part in Workspace
- Verify timer is counting down in Output

### Health Bars Not Showing
- Ensure HealthBarUI script is in StarterPlayerScripts
- Check that RemoteEvents are being created
- Verify PlayerHealthSystem is running

### Zombies Not Moving
- Check ZombieAI module is loaded
- Verify PathfindingService is enabled
- Make sure terrain is walkable

## Next Steps / Future Enhancements

Based on the initial requirements, here are planned features for future versions:

1. **Multiple Levels**: Add more diverse environments
2. **Multiplayer**: Add co-op gameplay
3. **Secret Rooms**: Hidden areas with rewards
4. **Boss Enemies**: Larger, stronger monsters
5. **More Weapons**: Bows, magic staffs, etc.
6. **Difficulty Levels**: Easy, Medium, Hard modes
7. **Persistent Rewards**: Save earned items between sessions
8. **More Enemy Types**: Different zombie variants, spiders
9. **Power-ups**: Health packs, damage boosts
10. **Sound Effects**: Combat sounds, background music

## File Structure

```
roblox_first_try/
├── game/
│   └── MonsterFightingGame.rbxl      # Roblox place file
├── src/
│   ├── ClientScripts/                # → StarterPlayer.StarterPlayerScripts
│   │   ├── HealthBarUI.lua
│   │   ├── WeaponSwitcher.lua
│   │   └── GameUI.lua
│   ├── ServerScripts/                # → ServerScriptService
│   │   ├── PlayerHealthSystem.lua
│   │   ├── WeaponSetup.lua
│   │   ├── CombatSystem.lua
│   │   ├── ZombieCreator.lua
│   │   ├── GameManager.lua
│   │   └── SpiderWebBuilder.lua
│   └── Modules/                      # → ReplicatedStorage.Modules
│       ├── GameConfig.lua
│       ├── WeaponManager.lua
│       └── ZombieAI.lua
├── default.project.json              # Rojo configuration
├── .gitignore                        # Git ignore patterns
├── README.md                         # This file
├── SETUP_GUIDE.md                    # Detailed setup instructions
└── PLAYER_REFERENCE.md               # Game controls and mechanics
```

## Script Dependencies

```
GameConfig (Module)
├─ Used by: PlayerHealthSystem, WeaponManager, ZombieAI, GameManager
│
WeaponManager (Module)
├─ Uses: GameConfig
├─ Used by: WeaponSetup, CombatSystem
│
ZombieAI (Module)
├─ Uses: GameConfig
├─ Used by: ZombieCreator
│
PlayerHealthSystem (Server)
├─ Uses: GameConfig
├─ Creates: RemoteEvents (HealthChanged, PlayerDied)
│
HealthBarUI (Client)
├─ Uses: RemoteEvents from PlayerHealthSystem
│
WeaponSetup (Server)
├─ Uses: WeaponManager
│
WeaponSwitcher (Client)
├─ Uses: GameConfig, WeaponManager
│
CombatSystem (Server)
├─ Uses: WeaponManager
│
ZombieCreator (Server)
├─ Uses: GameConfig, ZombieAI
│
GameManager (Server)
├─ Uses: GameConfig, ZombieCreator
├─ Creates: RemoteEvents (GameStateChanged, TimerUpdate)
│
GameUI (Client)
├─ Uses: RemoteEvents from GameManager
│
SpiderWebBuilder (Server)
└─ Creates: Visual spider web model
```

## Credits

Created for the monster-fighting game project.
Built with Roblox Studio and Lua scripting.

## License

Free to use and modify for your Roblox projects!
