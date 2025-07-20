extends Control

var coins: int;
var minigameCompleted: bool;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coins = 0; # For Debug purposes
	minigameCompleted = false;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_building_generate_coins(newCoins: int) -> void:
	coins += newCoins;
	$MainHUD/CoinsContainer/CoinsLabel.text = "Coins: %d" % coins;


func _on_main_hud_toggle_upgrades_menu() -> void:
	if !$MinigameHUD.visible:
		$UpgradesMenu.visible = !$UpgradesMenu.visible;


func _on_upgrades_menu_try_hire_worker(cost: int) -> void:
	if !checkCanAfford(cost):
		# TODO inform user that they are financially challenged via popup
		print("Oops! You don't have the money to afford that!");
	elif $Building.numWorkers == $Building.calc_worker_capacity():
		print("Oops! You don't have room for any more workers! Please buy more floors first.");
	else:
		coins -= cost;
		$Building.add_worker();
		$MainHUD/CoinsContainer/CoinsLabel.text = "Coins: %d" % coins;


func _on_upgrades_menu_try_purchase_upgrade(type: GlobalTypes.UpgradeType, cost: int) -> void:
	if !checkCanAfford(cost):
		# TODO inform user that they are financially challenged via popup
		print("Oops! You don't have the money to afford that!");
	else:
		coins -= cost;
		$Building.upgrade_building(type)
		$MainHUD/CoinsContainer/CoinsLabel.text = "Coins: %d" % coins;



func checkCanAfford(cost: int) -> bool:
	return coins - cost >= 0;


func _on_building_update_ui(currentWorkers: int, maxWorkers: int, pwrLevel: int, coinsLevel: int, numFloors: int, maxFloors: int) -> void:
	$UpgradesMenu.update_upgrades_menu(currentWorkers, maxWorkers, pwrLevel, coinsLevel, numFloors, maxFloors);
	$MainHUD/FloorContainer/FloorLabel.text = "Floors: %d" % numFloors;


func _on_main_hud_game_paused() -> void:
	get_tree().paused = !get_tree().paused;
	$PauseMenu.visible = get_tree().paused;


func _on_main_hud_minigame_begun() -> void:
	$MinigameHUD.visible = true;
	$UpgradesMenu.visible = false;


func _on_exit_button_pressed() -> void:
	# TODO exit to the title screen
	pass # Replace with function body.
