extends NinePatchRect

signal tryHireWorker;
signal tryPurchaseUpgrade;

@export var workerCost: int;

var currentPwrCost: int;
var currentCoinsCost: int;
var currentFloorCost: int;

const pwrUpgrades = [
	{ "level": 1, "coinCost": 100 },
	{ "level": 2, "coinCost": 300 },
	{ "level": 3, "coinCost": 750 },
	{ "level": 4, "coinCost": 1500 },
	{ "level": 5, "coinCost": 3000 },
]

const coinGenUpgrades = [
	{ "level": 1, "coinCost": 50 },
	{ "level": 2, "coinCost": 125 },
	{ "level": 3, "coinCost": 350 },
	{ "level": 4, "coinCost": 800 },
	{ "level": 5, "coinCost": 1400 },
]

const floorUpgrades = [
	{ "level": 2, "coinCost": 150 },
	{ "level": 3, "coinCost": 500 },
	{ "level": 4, "coinCost": 1250 },
	{ "level": 5, "coinCost": 3000 },
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_button_pressed() -> void:
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
	$ScrollContainer/VBoxContainer/UpgradePowerBtn/CostLabel.text = "Cost: $%d" % currentPwrCost if pwrLevel < 5 else "All upgrades purchased!";
	$ScrollContainer/VBoxContainer/UpgradeCoinsBtn/CostLabel.text = "Cost: $%d" % currentCoinsCost if coinsLevel < 5 else "All upgrades purchased!";
	$ScrollContainer/VBoxContainer/AddFloorBtn/CostLabel.text = "Cost: $%d" % currentFloorCost if numFloors < maxFloors else "All upgrades purchased!";


func _on_hire_worker_btn_pressed() -> void:
	tryHireWorker.emit(workerCost);


func _on_upgrade_power_btn_pressed() -> void:
	tryPurchaseUpgrade.emit(GlobalTypes.UpgradeType.POWER, currentPwrCost);


func _on_upgrade_coins_btn_pressed() -> void:
	tryPurchaseUpgrade.emit(GlobalTypes.UpgradeType.COINS, currentCoinsCost);


func _on_add_floor_btn_pressed() -> void:
	tryPurchaseUpgrade.emit(GlobalTypes.UpgradeType.FLOOR, currentFloorCost);
