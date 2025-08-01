extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/ItemDisplay

func update_display(slot: InventorySlot):
	if !slot:
		item_visual.visible = false
	else:
		item_visual.visible = true
		#item_visual.texture = slot.item.texture
