extends Panel

signal selected(index)

@export var index: int

@onready var item_visual: Sprite2D = $CenterContainer/Panel/ItemDisplay
@onready var amount_text: Label = $CenterContainer/Panel/Label
@onready var selection_indicator: Sprite2D = $SelectionIndicator

func update_display(slot: InventorySlot):
	
	if not slot.item:
		
		item_visual.visible = false
		amount_text.visible = false
		
	else:
		
		item_visual.visible = true
		amount_text.visible = true
		
		item_visual.texture = slot.item.texture
		amount_text.text = str(slot.amount)
	
	if slot.selected == true:
		selection_indicator.visible = true
	else:
		selection_indicator.visible = false
