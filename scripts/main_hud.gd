extends Control

signal minigameBegun;
signal workerHired;
signal buildingUpgraded;
signal gamePaused;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UpgradesButton.get_popup().connect("id_pressed", self, "_on_upgrades_menu_id_pressed");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pause_button_pressed() -> void:
	gamePaused.emit();


func _on_minigame_button_pressed() -> void:
	minigameBegun.emit();


func _on_building_changed_power_to(value: int) -> void:
	$PowerLevel.value = value;
