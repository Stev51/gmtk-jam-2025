extends Control

@export var player_inventory: Inventory

func add_to_player_inv(item: InventoryItem):
	player_inventory.insert(item)

func is_player_inv_free():
	return player_inventory.are_there_empty_slots()
