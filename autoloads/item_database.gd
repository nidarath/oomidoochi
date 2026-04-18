extends Node

# ItemDatabase:
# master dictionary of all items and their stats

var items: Dictionary = {
	"food": {
		"apple": {
			"id": "apple",
			"name": "Apple",
			"cost": 5,
			"nutrition": 10,
			"style": 0
		},
		"burger": {
			"id": "burger",
			"name": "Burger",
			"cost": 15,
			"nutrition": 30,
			"style": 0
		}
	},
	"clothes": {
		"tshirt": {
			"id": "tshirt",
			"name": "Basic T-Shirt",
			"cost": 20,
			"nutrition": 0,
			"style": 5
		},
		"jeans": {
			"id": "skirt",
			"name": "black skirt",
			"cost": 30,
			"nutrition": 0,
			"style": 10
		}
	},
	"gifts": {
		"teddy_bear": {
			"id": "teddy_bear",
			"name": "Teddy Bear",
			"cost": 50,
			"nutrition": 0,
			"style": 0,
			"happiness_boost": 20
		}
	}
}

# get item by catergory and id
func get_item(category: String, item_id: String) -> Dictionary:
	if items.has(category) and items[category].has(item_id):
		return items[category][item_id]
	return {}
