extends Control

signal minigameBegun;
signal toggleUpgradesMenu;
signal gamePaused;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pause_button_pressed() -> void:
	gamePaused.emit();


func _on_minigame_button_pressed() -> void:
	minigameBegun.emit();


func _on_building_changed_power_to(value: int) -> void:
	$PowerLevel.value = value;


func _on_upgrades_button_pressed() -> void:
	toggleUpgradesMenu.emit();
