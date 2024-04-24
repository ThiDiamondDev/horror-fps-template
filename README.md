# Godot Horror Game Inventory and Interaction System

## Overview

Welcome to the repository for the Inventory and Interaction System, a comprehensive solution designed for horror games developed in Godot. This system allows players to collect items, interact with the environment, and craft new items, enhancing the immersive experience of your game.

## Features

- **Inventory Management**: Players can collect and manage a variety of items within their inventory.
- **Item Interaction**: Items can be used or selected to interact with other elements in the game world.
- **Crafting System**: Players can craft new items by combining collected items according to specific recipes.
- **Interactive Environment**: The system includes interactive doors and drawers that can be locked/unlocked and opened/closed by dragging with the mouse.
- **Camcorder with Night Vision**: A camcorder equipped with night vision that players can use and recharge, adding a layer of depth to gameplay.

## Installation

1. Clone the repository or download the project from the GitHub page.
2. Open the project in Godot.
3. (Optional) Follow the integration instructions provided in the video tutorial to add the system to your game.

## Adding New Items and Crafting Recipes

1. To add new items, create a new item scene or prefab and define its properties.
2. To add crafting recipes, update the crafting system script with the new item combinations and their results.

## New Item Instructions

#### Create a New Scene

- Create a new scene file (e.g., `MyCollectibleItem.tscn`) inherited from `Interaction/Items/CollectibleItem.tscn`.

#### Add Mesh and Collision Shape

1. Attach a mesh to visually represent your collectible item.
2. Add a collision shape to ensure proper interaction with other objects.

#### Script for Collectible Item

1. Attach a script (e.g., `MyCollectibleItem.gd`) to your collectible item.
2. Extend `Interaction/Items/CollectibleItem.gd`.
3. (Optional) Implement the `on_collect` function within your script:

```gdscript
func on_collect(): # Custom logic for power cell collection
   Inventory.update_power_cells.emit()
```

This `on_collect` function will be called just after the signal to add the item to the inventory be emitted and before the item be removed with `queue_free()`, so if you want to change this behavior you need to override the `interact(parameters=null)` function.

#### Enable the “Use” Button

1. Define a static function called use_item in your script:

```gdscript
static func use_item(): # Custom logic for using the power cell
   Inventory.player.get_node("Head/Camcorder").try_to_recharge()
```

Here is the full source code to create a collectible and usable power cell:

```gdscript
extends "res://inventory-interaction-system/Interaction/Items/CollectibleItem.gd"

func on_collect():
    #Updates the power cells quantity label in the camcorder
    Inventory.update_power_cells.emit()

static func use_item():
    #Recharges the camcorder
    Inventory.player.get_node("Head/Camcorder").try_to_recharge()

```

## Showcase

- The project includes a demonstration of the inventory and interaction system in action.
- Watch the video tutorial to see how the system works and how to integrate it into your game.

## Contributing

Contributions are welcome! If you have any improvements or bug fixes, please feel free to fork the repository and submit a pull request.

## License

This project is released under the MIT License. See the LICENSE file for more details.

## Acknowledgments

- A special thanks to all the testers and contributors who have helped refine this system.

## Contact

If you have any questions or would like to contribute to the project, please open an issue in the repository or contact me directly.

Thank you for exploring the Inventory and Interaction System for your Godot horror game. Happy developing!
