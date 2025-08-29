extends Node2D

var discard_ref = null
var cards = []
var cards_left = 10
var deals_left = 5
var deals_label = 0
var win_label = 0

func _ready() -> void:
	# Loop from 1 to 10 to match card names Card1 to Card10
	for i in 10:
		var ref = find_child("Card" + str(i + 1))
		cards.append(ref)
	
	discard_ref = find_child("Discard")
	deals_label = find_child("DealsLabel")
	win_label = find_child("WinLabel")
	
	if deals_label:
		deals_label.text = "Deals left: " + str(deals_left)
	if win_label:
		win_label.text = ""

func play(id, num):
	var index = id - 1
	if index < 0 or index > 9 or cards[index] == null:
		return
	
	# Check if the card's number is one more or one less than the discard pile's number.
	if num != discard_ref.num + 1 and num != discard_ref.num - 1:
		return
		
	# Check if the card is blocked by cards on top of it.
	var row = int(sqrt(1.75 * id))
	var top1_id = (row + 1) * (row + 2) / 2 + id - row * (row + 1) / 2
	var top2_id = top1_id + 1
	
	# Cards with an id greater than 5 have no cards on top of them.
	if id <= 5 and (cards[int(top1_id - 1)] != null or cards[int(top2_id - 1)] != null):
		return
	
	# If all conditions are met, proceed with the play
	discard_ref.set_number(num)
	cards[index].set_visible(false)
	cards[index] = null
	
	cards_left -= 1
	check_win_or_lose()

func check_win_or_lose():
	if cards_left == 0:
		if win_label:
			win_label.text = "You Win!"
		# Exit the game after 5 seconds
		get_tree().create_timer(5.0).timeout.connect(func(): get_tree().quit())
	else:
		if deals_left == 0:
			var has_playable_card = false
			for card in cards:
				if card and (card.num == discard_ref.num + 1 or card.num == discard_ref.num - 1):
					var row = int(sqrt(1.75 * card.id))
					var top1_id = (row + 1) * (row + 2) / 2 + card.id - row * (row + 1) / 2
					var top2_id = top1_id + 1
					if card.id > 5 or (cards[int(top1_id - 1)] == null and cards[int(top2_id - 1)] == null):
						has_playable_card = true
						break
			if not has_playable_card:
				if win_label:
					win_label.text = "You Lose"

func _on_new_game_button_pressed():
	get_tree().reload_current_scene()

func _on_deal_button_pressed() -> void:
	if deals_left > 0:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		discard_ref.set_number(rng.randi_range(1, 13))
		deals_left -= 1
		if deals_label:
			deals_label.text = "Deals left: " + str(deals_left)
	check_win_or_lose()
