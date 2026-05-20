# LVENGINE
LVENGINE is an Undertale engine made in Godot.

## What does it have to offer?
- 60 FPS
- Easy item creation, enemy creation, battles, overworld, NPCs
- By NPCs, I mean there's a class you can extend with an `interact()` function that runs when you interact with the NPC
- A recreation of Undertale's menu, with support for the aforementioned custom items and stats actually updating!
- ...
- A dog?
- No, two dogs...
- Three dogs now?
- Oh, four dogs... all on the settings screen... but you can't see them all at once.
- ... also this mystery man that disappears when I interact with him

## To-do
- Battle system and its attack modes
- Add more good settings
- Lose my sanity

## How use?
Download this project's source. Then open the project in Godot (4.6.2).  
Items can be found in `res://data/items/`, enemies and encounters can be found in the same `data` directory  
Use `TileMapLayer` and a spritesheet to make your maps. This project comes with an example Ruins spritesheet with collisions.  

If you don't hear any music, enable music in settings and **install Undertale via Steam**. Undertale detection does not work on other OSs.
