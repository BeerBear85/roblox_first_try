# Monster Fighting Game - Player Reference Card

## Controls

| Key | Action |
|-----|--------|
| **W A S D** | Move around |
| **Space** | Jump |
| **Mouse Click** | Attack with weapon |
| **1** | Equip Normal Sword |
| **2** | Equip Knife |
| **3** | Equip Fire Sword |

## Weapon Stats

### Normal Sword [1]
- **Damage**: 20 HP
- **Speed**: Medium
- **Range**: 8 studs
- **Best for**: Balanced combat
- **Hits to kill zombie**: 3 hits

### Knife [2]
- **Damage**: 15 HP
- **Speed**: Fast (0.5s cooldown)
- **Range**: 5 studs (short)
- **Best for**: Quick hit-and-run attacks
- **Hits to kill zombie**: 4 hits

### Fire Sword [3]
- **Damage**: 35 HP
- **Speed**: Slow (1.5s cooldown)
- **Range**: 9 studs
- **Best for**: Heavy damage, fewer swings
- **Hits to kill zombie**: 2 hits

## Game Flow

1. **Preparation Phase (0:00 - 1:00)**
   - Timer counts down from 60 seconds
   - Walk around and get familiar with controls
   - Practice switching weapons (keys 1, 2, 3)
   - Position yourself near the spider web spawn

2. **Combat Phase (After 1:00)**
   - 4 zombies spawn around the giant spider web
   - Zombies will chase and attack you
   - Use your weapons to fight back
   - Monitor your health (bottom of screen)

3. **Victory**
   - Defeat all 4 zombies
   - "VICTORY!" message appears
   - You earn the Survivor's Badge

## Enemy Info

### Zombie
- **Health**: 50 HP
- **Damage**: 10 HP per hit
- **Speed**: Slow (12 studs/second)
- **Behavior**: Chases nearest player, attacks when close
- **Attack Range**: 5 studs
- **Attack Cooldown**: 2 seconds

## Health System

- **Your Health**: 100 HP
- **Health Bar**: Bottom of screen (green/yellow/red)
- **Zombie Health**: Above their heads (red bar)
- **You can survive**: 10 zombie hits
- **Zombies can survive**: 2-4 weapon hits (depends on weapon)

## Combat Tips

### General Strategy
1. **Keep moving!** Don't let zombies surround you
2. **Use range** - Hit zombies before they can hit you
3. **Switch weapons** based on situation
4. **Watch health** - Both yours and the zombies'

### Weapon Tactics

**Use Normal Sword when:**
- Fighting 1-2 zombies
- You want balanced damage and speed
- Learning enemy patterns

**Use Knife when:**
- Kiting (hit and run)
- Multiple zombies are close
- You need quick successive attacks
- Low on health (faster retreat)

**Use Fire Sword when:**
- Fighting single targets
- You can time your attacks well
- Want to finish zombies quickly
- Have backup space to dodge

### Advanced Tactics

**Crowd Control:**
- Lead zombies in a line
- Attack the front zombie
- Back up while attacking
- Repeat until all defeated

**Hit and Run:**
1. Equip Knife [2]
2. Run toward zombie
3. Attack once
4. Run away before they hit back
5. Repeat

**Tank Method:**
1. Equip Fire Sword [3]
2. Let zombie approach
3. Attack right before they reach you
4. Back up slightly
5. Wait for cooldown
6. Repeat

## Survival Math

### How many hits can you take?
- **Your HP**: 100
- **Zombie damage**: 10
- **You can survive**: 10 hits (then you die)

### How many hits to kill a zombie?
- **Zombie HP**: 50
- **Sword**: 3 hits (20 damage × 3 = 60)
- **Knife**: 4 hits (15 damage × 4 = 60)
- **Fire Sword**: 2 hits (35 damage × 2 = 70)

### Total Combat Duration
- **4 zombies** × **2-4 hits each** = 8-16 total attacks needed
- **Sword**: ~8-10 seconds
- **Knife**: ~6-8 seconds (faster swings)
- **Fire Sword**: ~12-14 seconds (slower swings)

## Win Conditions

✅ **Victory Requirements:**
- Defeat all 4 zombies
- Stay alive (HP > 0)

⭐ **Perfect Run:**
- Take 0 damage
- Use all 3 weapons
- Defeat all zombies in under 30 seconds

## Troubleshooting

**Problem**: Can't switch weapons
- **Solution**: Make sure you're not in the middle of attacking

**Problem**: Zombie health not showing
- **Solution**: Look directly at zombie's head

**Problem**: Taking too much damage
- **Solution**: Keep distance, use knife for faster attacks

**Problem**: Can't find zombies
- **Solution**: Look for the giant spider web (glowing white)

**Problem**: Timer stuck
- **Solution**: Wait for all scripts to load (check Output)

## UI Guide

### Top of Screen
- **Timer**: Shows countdown to zombie spawn
- **"MONSTERS INCOMING"**: Warning message

### Bottom of Screen
- **Health Bar**: Your HP (green = healthy, yellow = hurt, red = critical)
- **Health Numbers**: "X / 100" (current / max)

### Middle Left
- **Weapon Display**: Shows current weapon and hotkey
  - Example: "Weapon: Fire Sword [3]"

### Center (When you win)
- **Victory Screen**: "VICTORY!" message
- **Reward**: "All monsters defeated! You have earned: Survivor's Badge"

## Quick Reference Stats

| Stat | Value |
|------|-------|
| Your HP | 100 |
| Your Speed | 16 studs/sec |
| Zombie HP | 50 |
| Zombie Speed | 12 studs/sec |
| Zombie Damage | 10 |
| Zombie Count | 4 |
| Spawn Time | 60 seconds |

---

**Good luck, warrior! The monsters await! 🗡️🧟**
