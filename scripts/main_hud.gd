extends Control

signal minigameBegun;
signal toggleUpgradesMenu;
signal gamePaused;

func _on_pause_button_pressed() -> void:
	gamePaused.emit();


func _on_minigame_button_pressed() -> void:
	minigameBegun.emit();


func _on_upgrades_button_pressed() -> void:
	toggleUpgradesMenu.emit();
