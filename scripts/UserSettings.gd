extends Control

enum SLOTS{
	PANTS,
	SHIRT,
	SKIN,
	HAIR,
	SHOES
}

var current_slot : int = SLOTS.PANTS

# Needs to use the paths before it's ready, so it will crash using onready
var text_edit1 : String = "VBoxContainer/UsernameContainer/UsernameTextEdit"
var gender_edit : String = "VBoxContainer/Gender"
var avatar_preview : String = "VBoxContainer2/ViewportContainer/Viewport/AvatarPreview"
var hue_picker : String = "VBoxContainer/HuePicker"
var button_containter : String = "VBoxContainer2/ViewportContainer"


func _ready() -> void:
	#warning-ignore:return_value_discarded
	Options.connect( "username_changed", get_node( text_edit1 ), "set_text" )
	
	get_node(text_edit1).text = Options.username
	switch_slot()
	_on_Gender_item_selected(Options.gender)
	get_node(gender_edit).selected = int(Options.gender)
	get_node(button_containter).get_node("Viewport").size = get_node(button_containter).rect_size

func switch_slot() -> void:
	if current_slot == SLOTS.PANTS:
		get_node(hue_picker).color = Options.pants_color
	elif current_slot == SLOTS.SHIRT:
		get_node(hue_picker).color = Options.shirt_color
	elif current_slot == SLOTS.SKIN:
		get_node(hue_picker).color = Options.skin_color
	elif current_slot == SLOTS.HAIR:
		get_node(hue_picker).color = Options.hair_color
	elif current_slot == SLOTS.SHOES:
		get_node(hue_picker).color = Options.shoes_color
	get_node(avatar_preview).set_colors(Options.pants_color, Options.shirt_color, Options.skin_color, Options.hair_color, Options.shoes_color)

func _on_HuePicker_Hue_Selected(color : Color) -> void:
	if current_slot == SLOTS.PANTS:
		Options.pants_color = color
	elif current_slot == SLOTS.SHIRT:
		Options.shirt_color = color
	elif current_slot == SLOTS.SKIN:
		Options.skin_color = color
	elif current_slot == SLOTS.HAIR:
		Options.hair_color = color
	elif current_slot == SLOTS.SHOES:
		Options.shoes_color = color
	get_node(avatar_preview).set_colors(Options.pants_color, Options.shirt_color, Options.skin_color, Options.hair_color, Options.shoes_color)

func _on_CfgPlayer_pressed() -> void:
	$WindowDialog.popup_centered()

func _on_SaveButton_pressed() -> void:
	Options.save()
	
	#Let everyone know the name has been changed.
	Options.set_username( get_node( text_edit1 ).text )
	
#	UIManager.back()

func _on_SlotOption_item_selected(ID : int) -> void:
	get_node(avatar_preview).clean_selected()
	get_node(avatar_preview).set_selected(ID)
	current_slot = ID
	switch_slot()


func _on_Gender_item_selected(ID : int) -> void:
	Options.gender = ID
	get_node(avatar_preview).set_gender(Options.gender)
	if ID == 0:
		get_node(button_containter).get_node("Female").show()
		get_node(button_containter).get_node("Male").hide()
	else:
		get_node(button_containter).get_node("Female").hide()
		get_node(button_containter).get_node("Male").show()