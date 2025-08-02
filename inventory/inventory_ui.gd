extends Control

@onready var inventory: Inventory = preload("res://inventory/inventories/player_inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open = false

func _ready():
	
	inventory.update_inv.connect(update_slots)
	
	update_slots()
	open()

func open():
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false

func update_slots():
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update_display(inventory.slots[i])
