"""

	Use this class for showing-up independent screens within the game.

"""

tool
extends Spatial

export(Array, Texture) var texture_slides
export(Array, String) var text_slides
var slide_index: int = 0
var slide_size: int = 0


func _content_prepared(slide_control) -> void :
	slide_control.connect("next_pressed", self, "_on_next_pressed", [slide_control])
	slide_control.connect("prev_pressed", self, "_on_prev_pressed", [slide_control])
	
	if texture_slides.size() != text_slides.size():
		assert(false)
		Log.error(self, "_ready", "Texture array size is not the same as text array size.")
	else:
		slide_size = texture_slides.size()
	
	#At start of scene, make SlidePresentation display first slide.
	if not text_slides.empty() :
		slide_control.set_text(text_slides[0])
		slide_control.set_texture(texture_slides[0])

func _ready():
	$Screen.connect("content_prepared", self, "_content_prepared")

func _on_next_pressed(slide_control):
	if slide_size > slide_index + 1:
		slide_index += 1
	else:
		slide_index = 0
	slide_control.texture = texture_slides[slide_index]
	slide_control.text = text_slides[slide_index]

func _on_prev_pressed(slide_control):
	if slide_index > 0:
		slide_index -= 1
	else:
		slide_index = slide_size - 1
	slide_control.texture = texture_slides[slide_index]
	slide_control.text = text_slides[slide_index]