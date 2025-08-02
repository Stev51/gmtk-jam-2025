extends Control

@onready var inventory: Inventory = preload("res://inventory/inventories/player_inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open = false

func _ready():
	
	inventory.update_inv.connect(update_slots)
	
	for slot in slots:
		slot.selected.connect(change_selection)
	
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

func change_selection(index: int):
	
	if inventory.selected == true:
		inventory.slots[inventory.selection_index].selected = false
	
	if index == inventory.selection_index:
		
		inventory.selected = false
		inventory.selection_index = null
		
	else:
		
		inventory.selected = true
		inventory.selection_index = index
		
		inventory.slots[inventory.selection_index].selected = true
	
	update_slots()
	inventory.check_selection_state()

func _input(event):
	if event.is_action_pressed("ui_one"):
		change_selection(0)
	elif event.is_action_pressed("ui_two"):
		change_selection(1)
	elif event.is_action_pressed("ui_three"):
		change_selection(2)
	elif event.is_action_pressed("ui_four"):
		change_selection(3)
	elif event.is_action_pressed("ui_five"):
		change_selection(4)
	elif event.is_action_pressed("ui_six"):
		change_selection(5)
	elif event.is_action_pressed("ui_seven"):
		change_selection(6)
	elif event.is_action_pressed("ui_eight"):
		change_selection(7)
	elif event.is_action_pressed("ui_nine"):
		change_selection(8)
