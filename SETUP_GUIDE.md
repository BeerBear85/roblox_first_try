# Quick Setup Guide

Follow these steps to get your game running in Roblox Studio.

## Method 1: Automated Setup with Rojo (RECOMMENDED)

Rojo automatically syncs your code from the `src/` folder into Roblox Studio. No more manual copying!

### Step 1: Install Rojo

**Option A: Install via Cargo (if you have Rust)**
```bash
cargo install rojo
```

**Option B: Download Pre-built Binary**
1. Visit https://github.com/rojo-rbx/rojo/releases/latest
2. Download the appropriate version for your OS:
   - Windows: `rojo-X.X.X-windows.zip`
   - macOS: `rojo-X.X.X-macos.zip`
   - Linux: `rojo-X.X.X-linux.zip`
3. Extract and add to your PATH

**Option C: Install via Aftman (Roblox package manager)**
```bash
aftman add rojo-rbx/rojo
```

Verify installation:
```bash
rojo --version
```

### Step 2: Install Rojo Studio Plugin

1. Open Roblox Studio
2. Visit the Rojo plugin page: https://www.roblox.com/library/13916111004/Rojo-7
3. Click **Install** to add it to Roblox Studio
4. Restart Roblox Studio

### Step 3: Create Project in Roblox Studio

1. Open Roblox Studio
2. Select **Baseplate** template
3. Save as `MonsterFightingGame` in the `game/` folder of this project
   - Use the existing `game/MonsterFightingGame.rbxl` if it's already there

4. Create one folder manually (Rojo will populate it):
   - In **ReplicatedStorage**: Create a **Folder** named `RemoteEvents` (leave empty)

### Step 4: Start Rojo Sync

1. Open a terminal in the project directory: `C:\repositories\roblox_first_try`

2. Start the Rojo server:
```bash
rojo serve
```

You should see:
```
Rojo server listening on port 34872
```

3. In Roblox Studio, click the **Rojo** button in the toolbar
4. Click **Connect**
5. Click **Sync In** to load all your code

**That's it!** Your entire `src/` folder is now synced to Studio:
- `src/Modules/` → `ReplicatedStorage.Modules`
- `src/ServerScripts/` → `ServerScriptService`
- `src/ClientScripts/` → `StarterPlayer.StarterPlayerScripts`

### Step 5: Development Workflow

**While developing:**
1. Keep `rojo serve` running in your terminal
2. Edit code in VS Code (or your preferred editor)
3. Save the file
4. Changes automatically appear in Roblox Studio!

**Optional: VS Code Extension**
Install the "Rojo" extension in VS Code for better integration:
- Search "Rojo" in VS Code Extensions
- Provides syntax highlighting and inline tools

### Step 6: Create Basic Terrain (Optional)

**Quick Option**: Skip this - the game works on baseplate!

**Forest Option**:
1. Click **Home** tab → **Editor** section → **Terrain Editor**
2. Select **Generate**
3. Choose settings:
   - Biome: Woodlands
   - Size: 512x512 (Medium)
4. Click **Generate**

### Step 7: Test Your Game!

1. Click the **Play** button (or press F5)
2. You should see:
   - Health bar at bottom of screen
   - Weapon indicator showing "Normal Sword [1]"
   - Timer at top: "MONSTERS INCOMING - 60"
   - A sword in your hand

3. Wait 60 seconds (or change SpawnDelay in GameConfig to test faster)
4. Zombies will spawn around a spider web
5. Fight them with your weapons!

---

## Method 2: Manual Setup (Fallback)

If you can't use Rojo, follow these manual steps:

### Step 1: Create Project
1. Open Roblox Studio
2. Select "Baseplate" template
3. Save as "MonsterFightingGame"

### Step 2: Setup ReplicatedStorage

1. Select **ReplicatedStorage** in Explorer
2. Click the **+** button → Insert Object → **Folder**
3. Name it `Modules`

4. Inside the Modules folder, create 3 **ModuleScripts**:
   - Right-click Modules → Insert Object → ModuleScript
   - Rename them to:
     - `GameConfig`
     - `WeaponManager`
     - `ZombieAI`

5. Copy the code from these files into each ModuleScript:
   - `src/Modules/GameConfig.lua` → GameConfig
   - `src/Modules/WeaponManager.lua` → WeaponManager
   - `src/Modules/ZombieAI.lua` → ZombieAI

6. Create another **Folder** in ReplicatedStorage called `RemoteEvents`
   - Leave it empty (scripts will populate it)

### Step 3: Setup ServerScriptService

1. Select **ServerScriptService** in Explorer
2. Create 6 **Scripts** (not LocalScripts!):
   - Right-click ServerScriptService → Insert Object → Script
   - Create and name them:
     - `PlayerHealthSystem`
     - `WeaponSetup`
     - `CombatSystem`
     - `ZombieCreator`
     - `GameManager`
     - `SpiderWebBuilder`

3. Copy code from these files:
   - `src/ServerScripts/PlayerHealthSystem.lua` → PlayerHealthSystem
   - `src/ServerScripts/WeaponSetup.lua` → WeaponSetup
   - `src/ServerScripts/CombatSystem.lua` → CombatSystem
   - `src/ServerScripts/ZombieCreator.lua` → ZombieCreator
   - `src/ServerScripts/GameManager.lua` → GameManager
   - `src/ServerScripts/SpiderWebBuilder.lua` → SpiderWebBuilder

### Step 4: Setup StarterPlayer Scripts

1. In Explorer, expand **StarterPlayer**
2. Expand **StarterPlayerScripts**
3. Create 3 **LocalScripts**:
   - Right-click StarterPlayerScripts → Insert Object → LocalScript
   - Create and name them:
     - `HealthBarUI`
     - `WeaponSwitcher`
     - `GameUI`

4. Copy code from these files:
   - `src/ClientScripts/HealthBarUI.lua` → HealthBarUI
   - `src/ClientScripts/WeaponSwitcher.lua` → WeaponSwitcher
   - `src/ClientScripts/GameUI.lua` → GameUI

### Step 5: Test (same as Method 1, Step 7)

---

## Visual Checklist

Your Explorer should look like this:

```
Workspace
├─ Baseplate
├─ Camera
└─ (Spider web and spawn point will appear when game runs)

ReplicatedStorage
├─ Modules (Folder)
│  ├─ GameConfig (ModuleScript)
│  ├─ WeaponManager (ModuleScript)
│  └─ ZombieAI (ModuleScript)
└─ RemoteEvents (Folder - empty)

ServerScriptService
├─ PlayerHealthSystem (Script)
├─ WeaponSetup (Script)
├─ CombatSystem (Script)
├─ ZombieCreator (Script)
├─ GameManager (Script)
└─ SpiderWebBuilder (Script)

StarterPlayer
└─ StarterPlayerScripts
   ├─ HealthBarUI (LocalScript)
   ├─ WeaponSwitcher (LocalScript)
   └─ GameUI (LocalScript)
```

## Common Mistakes to Avoid

❌ **Wrong Script Type**
- ServerScriptService needs **Scripts** (not LocalScripts)
- StarterPlayerScripts needs **LocalScripts** (not Scripts)
- Modules folder needs **ModuleScripts**

❌ **Wrong Location**
- Don't put client scripts in ServerScriptService
- Don't put server scripts in StarterPlayerScripts
- Modules must be in ReplicatedStorage

❌ **Typos in Names**
- Script names must match exactly (case-sensitive)
- Folder names must be exact

✅ **Everything Working?**
Check the Output window (View → Output) for:
- "PlayerHealthSystem initialized"
- "WeaponSetup initialized"
- "CombatSystem initialized"
- "ZombieCreator initialized"
- "GameManager initialized"
- "SpiderWebBuilder initialized"
- "Game starting! Zombies will spawn in 60 seconds..."

## Quick Balance Changes

Want to test faster? Edit `GameConfig` ModuleScript:

```lua
-- Change spawn delay from 60 to 10 seconds
SpawnDelay = 10,

-- Change zombie count from 4 to 2 for easier testing
ZombieCount = 2,

-- Make weapons more powerful
Sword = {
    Damage = 50,  -- One-shot zombies!
    ...
}
```

## Need Help?

Check these:
1. **Output Window** - Shows errors and debug messages
2. **Script Analysis** - Yellow warnings tell you about issues
3. **All scripts enabled?** - Make sure no scripts are disabled (grayed out)

## Ready to Play!

Once everything is set up:
- Press **F5** to play
- Press **1, 2, 3** to switch weapons
- **Click** to attack
- Survive 60 seconds, then defeat all zombies!

Good luck, and have fun! 🎮
