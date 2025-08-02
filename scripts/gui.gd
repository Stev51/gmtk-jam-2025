extends Control

@export var player_inventory: Inventory

func add_to_player_inv(item: InventoryItem):
	player_inventory.insert(item)
