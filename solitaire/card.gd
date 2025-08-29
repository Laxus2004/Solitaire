extends Sprite2D
var num = 0
var num_ref = null
static var rand = RandomNumberGenerator.new()
var id = 0

func _ready() -> void:
	var name = get_name().replace("Card", "")
	if name == "Discard":
		id = 10
	else:
		id = int(name)
	print(id)
	
	num_ref = find_child("Number")
	set_number(rand.randi_range(1, 13))


func set_number(n:int):
	self.num = n
	num_ref.text = str(n)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			owner.play(id, num)
