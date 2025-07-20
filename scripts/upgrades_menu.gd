extends NinePatchRect

signal tryHireWorker;
signal tryPurchaseUpgrade;

@export var workerCost: int;

var currentPwrCost: int;
var currentCoinsCost: int;
var currentFloorCost: int;

const pwrUpgrades = [
	{ "level": 1, "coinCost": 75 },
	{ "level": 2, "coinCost": 300 },
	{ "level": 3, "coinCost": 1200 },
	{ "level": 4, "coinCost": 4800 },
	{ "level": 5, "coinCost": 18600 },
]

const coinGenUpgrades = [
	{ "level": 1, "coinCost": 75 },
	{ "level": 2, "coinCost": 350 },
	{ "level": 3, "coinCost": 900 },
	{ "level": 4, "coinCost": 2700 },
	{ "level": 5, "coinCost": 9500 },
]

const floorUpgrades = [
	{ "level": 2, "coinCost": 500 },
	{ "level": 3, "coinCost": 2500 },
	{ "level": 4, "coinCost": 12500 },
	{ "level": 5, "coinCost": 55000 },
]


func _on_close_button_pressed() -> void:
	$ClickSFXPlayer.play();
	visible = false;


func update_upgrades_menu(numWorkers: int, maxWorkers: int, pwrLevel: int, coinsLevel: int, numFloors: int, maxFloors: int) -> void:
	$ScrollContainer/VBoxContainer/HireWorkerBtn/WorkersLabel.text = "Workers: %d/%d" % [numWorkers, maxWorkers];
	$ScrollContainer/VBoxContainer/UpgradePowerBtn/LevelLabel.text = "Current Level: %d" % pwrLevel;
	$ScrollContainer/VBoxContainer/UpgradeCoinsBtn/LevelLabel.text = "Current Level: %d" % coinsLevel;
	$ScrollContainer/VBoxContainer/AddFloorBtn/FloorsLabel.text = "Floors: %d/%d" % [numFloors, maxFloors];
	
	var hasMaxPwrLevel = true;
	for upgrade in pwrUpgrades:
		if upgrade["level"] == pwrLevel + 1:
			currentPwrCost = upgrade["coinCost"];
			hasMaxPwrLevel = false;
			break;
	
	var hasMaxCoinsLevel = true;
	for upgrade in coinGenUpgrades:
		if upgrade["level"] == coinsLevel + 1:
			currentCoinsCost = upgrade["coinCost"];
			hasMaxCoinsLevel = false;
			break;
	
	var hasMaxFloors = true;
	for upgrade in floorUpgrades:
		if upgrade["level"] == numFloors + 1:
			currentFloorCost = upgrade["coinCost"];
			hasMaxFloors = false;
			break;
	
	$ScrollContainer/VBoxContainer/HireWorkerBtn/CostLabel.text = "Cost: $%d" % workerCost if numWorkers < maxWorkers and numFloors < maxFloors else "No more room!";
	$ScrollContainer/VBoxContainer/UpgradePowerBtn/CostLabel.text = "Cost: $%d" % currentPwrCost if pwrLevel < 5 else "Got all upgrades!";
	$ScrollContainer/VBoxContainer/UpgradeCoinsBtn/CostLabel.text = "Cost: $%d" % currentCoinsCost if coinsLevel < 5 else "Got all upgrades!";
	$ScrollContainer/VBoxContainer/AddFloorBtn/CostLabel.text = "Cost: $%d" % currentFloorCost if numFloors < maxFloors else "Got all upgrades!";


func _on_hire_worker_btn_pressed() -> void:
	$ClickSFXPlayer.play();
	tryHireWorker.emit(workerCost);


func _on_upgrade_power_btn_pressed() -> void:
	$ClickSFXPlayer.play();
	tryPurchaseUpgrade.emit(GlobalTypes.UpgradeType.POWER, currentPwrCost);


func _on_upgrade_coins_btn_pressed() -> void:
	$ClickSFXPlayer.play();
	tryPurchaseUpgrade.emit(GlobalTypes.UpgradeType.COINS, currentCoinsCost);


func _on_add_floor_btn_pressed() -> void:
	$ClickSFXPlayer.play();
	tryPurchaseUpgrade.emit(GlobalTypes.UpgradeType.FLOOR, currentFloorCost);
