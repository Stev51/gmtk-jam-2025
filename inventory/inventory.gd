extends Resource
class_name Inventory

signal update_inv

@export var slots: Array[InventorySlot]

var selected: bool = false
var selection_index = null

func insert(item: InventoryItem):
	
	# Find slots that already have item type
	var item_slots = slots.filter(func(slot): return slot.item == item)
	if not item_slots.is_empty(): #If item already in inventory, put it in first existing slot
		item_slots[0].amount += 1
	else: #If item not present, try to put it in an empty slot
		
		# Find empty slots
		var empty_slots = slots.filter(func(slot): return slot.item == null)
		if not empty_slots.is_empty(): #If empty slots exist, put item in first available one
			empty_slots[0].item = item
			empty_slots[0].amount = 1
	
	# Once done, signal GUI update
	update_inv.emit()

func are_there_empty_slots():
	var empty_slots = slots.filter(func(slot): return slot.item == null)
	return not empty_slots.is_empty()
