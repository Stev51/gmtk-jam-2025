extends Node2D

@onready var display_node = $ItemDisplay
@onready var text_node = $ItemText

var current_item: InventoryItem

func _ready():
	display_node.texture = null
	text_node.text = format_text("Nothing yet!")

func set_new_item(item: InventoryItem):
	current_item = item
	display_node.texture = item.texture
	text_node.text = format_text(item.name)

func set_new_mechanism(mech: Mechanism):
	set_new_item(mech.item)

func format_text(text):
	return "[b]" + text + "[/b]"
