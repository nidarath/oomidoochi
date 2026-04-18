extends Node

# The Oomi Tracker

var oomis: Dictionary = {}

# generate a oomi profile and save it in our dict
func create_oomi(id: String, first_name: String, last_name: String, birthdate: String) -> Dictionary:
	var oomi = {
		"id": id,
		"first_name": first_name,
		"last_name": last_name,
		"birthdate": birthdate,
		"needs": {
			"hunger": 80.0, # 0 to 100 — starts at 80 so feeding is observable from the start
			"happiness": 50.0 # 0 to 100
		},
		"personality": {
			# slider from 1-10
			"energy": randi_range(1, 10), #energetic - eepy
			"quirkiness": randi_range(1, 10), # quirky - normal
			"expressiveness": randi_range(1, 10), # expressive - dull
			"cortisol": randi_range(1, 10) # low - high
		},
		"preferences":{
			"favorite_food": "",
			"hated food": "",
			"favorite color": "light blue"
		},
		"voice":{
			"pitch": randf_range(0.6, 1.4), # High or low pitch modifier
			"speed": randf_range(0.8, 1.2)  # Fast or slow talker
		},
		"catchphrase": "Oh my!",
		# social
		"relationships": {}, # status on other oomis {"oomi_02": 85, "oomi_03": -10}
		"current_state": "idle", # idle, sleeping, talking, eating
		"money": 0, # pocket money
		# inventory: gifts and clothes
		"inventory": [],
		# current clothes
		"wardrobe": {
			"top": "tshirt",
			"bottom": "skirt"
		},
		"room_decor": {
			"wallpaper": "basic_walls",
			"floor": "wood_floor"
		}
	}
	oomis[id] = oomi
	return oomi

# get oomi by id
func get_oomi(id: String) -> Dictionary:
	if oomis.has(id):
		return oomis[id]
	return {}

# give an item to a character's inventory
# returns true if the item was added, false if the oomi doesn't exist or already has it
func give_item(id: String, item_id: String) -> bool:
	if not oomis.has(id):
		push_error("CharacterManager: give_item called with unknown id: " + id)
		return false
	if oomis[id]["inventory"].has(item_id):
		return false
	oomis[id]["inventory"].append(item_id)
	return true
			
# feed an oomi
func feed_oomi(id: String, food_id: String):
	var food = ItemDatabase.get_item("food", food_id)
	if food.is_empty():
		return
	if oomis.has(id):
		var nutrition = food.get("nutrition", 0)
		oomis[id]["needs"]["hunger"] += nutrition
		oomis[id]["needs"]["hunger"] = clamp(oomis[id]["needs"]["hunger"], 0.0, 100.0)