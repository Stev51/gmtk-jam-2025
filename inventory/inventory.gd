extends Resource
class_name Inventory

@export var slots: Array[InventorySlot]

func insert(item: InventoryItem):
	print(item.name)
