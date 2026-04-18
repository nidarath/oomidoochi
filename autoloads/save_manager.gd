extends Node
# SaveManager (Autoload)
# Script that uses Godot's FileAccess and JSON classes to save the list
# of Oomis and their inventories to the user:// directory.

const SAVE_PATH = "user://oomi_save.json"
const TEMP_PATH = "user://oomi_save.json.tmp"
const SAVE_VERSION = 1


# Saves the current state of characters to disk
func save_game() -> bool:
	# oomis is already a plain Dictionary so it serializes directly
	var save_data = {
		"version": SAVE_VERSION,
		"oomis": CharacterManager.oomis
	}

	var json_string = JSON.stringify(save_data, "\t")

	# temp file incase game crashes 
	# the real save file stays intact
	var file = FileAccess.open(TEMP_PATH, FileAccess.WRITE)
	if not file:
		push_error("SaveManager: Failed to open temp file for writing.")
		return false

	file.store_string(json_string)
	file.close()

	# Atomic swap — only replaces the real save if the write succeeded
	var err = DirAccess.rename_absolute(
		ProjectSettings.globalize_path(TEMP_PATH),
		ProjectSettings.globalize_path(SAVE_PATH)
	)
	if err != OK:
		push_error("SaveManager: Failed to replace save file after writing. Error: " + str(err))
		return false

	print("SaveManager: Game saved successfully to ", SAVE_PATH)
	return true


# Loads the saved game from disk and replaces current memory
func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		print("SaveManager: No save file found.")
		return false

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		push_error("SaveManager: Failed to open save file for reading.")
		return false

	var json_string = file.get_as_text()
	file.close()

	var json = JSON.new()
	var error = json.parse(json_string)
	if error != OK:
		push_error("SaveManager: Error parsing JSON at line " + str(json.get_error_line()) + ": " + json.get_error_message())
		return false

	var save_data = json.data
	if typeof(save_data) != TYPE_DICTIONARY or not save_data.has("oomis"):
		push_error("SaveManager: Save data structure is invalid.")
		return false

	# Cast to int — JSON loads all numbers as floats, which breaks integer comparison
	var version = int(save_data.get("version", 0))
	if version < SAVE_VERSION:
		print("SaveManager: Old save version ", version, " detected — migrating.")
		# Add migration logic here as the game evolves

	# oomis is a plain Dictionary so we can assign it directly
	CharacterManager.oomis = save_data["oomis"]
	print("SaveManager: Game loaded successfully. Version: ", version)
	return true


# Deletes the save file — useful for a "New Game" option
func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))
		print("SaveManager: Save file deleted.")


# Returns true if a save file exists — use this on the main menu
# to decide whether to show a "Continue" button
func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)
