extends Node2D

signal generateCoins;

@export var maxPower: int;
@export var maxPwrLevel: int;
@export var maxCoinLevel: int;
@export var initCoinGenRate: float;
@export var pwrConsumptionRate: float;
@export var maxFloors: int;

var currentPower: float;
var currentCoinGenRate: float;
var numWorkers: int;
var numFloors: int;
var powerLevel: int;
var coinLevel: int;

var pwrUpgrades;
var coinGenUpgrades;
var floorUpgrades;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentPower = maxPower;
	currentCoinGenRate = initCoinGenRate;
	numWorkers = 0;
	numFloors = 1;
	powerLevel = 0;
	coinLevel = 0;
	
	pwrUpgrades = [
		{ "level": 1, "coinCost": 100 },
		{ "level": 2, "coinCost": 300 },
		{ "level": 3, "coinCost": 750 },
		{ "level": 4, "coinCost": 1500 },
		{ "level": 5, "coinCost": 3000 },
	]
	
	coinGenUpgrades = [
		{ "level": 1, "coinCost": 50 },
		{ "level": 2, "coinCost": 125 },
		{ "level": 3, "coinCost": 350 },
		{ "level": 4, "coinCost": 800 },
		{ "level": 5, "coinCost": 1400 },
	]
	
	floorUpgrades = [
		{ "level": 2, "coinCost": 150 },
		{ "level": 3, "coinCost": 500 },
		{ "level": 4, "coinCost": 1250 },
		{ "level": 5, "coinCost": 3000 },
	]
	
	$PowerDegradeTimer.wait_time = 1 / pwrConsumptionRate;
	$PowerDegradeTimer.start();
	
	$CoinGenerateTimer.wait_time = 1 / currentCoinGenRate;
	$CoinGenerateTimer.start();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	currentCoinGenRate = 0 if currentPower == 0 else initCoinGenRate;


func upgrade_building(type: GlobalTypes.UpgradeType) -> void:
	if type == GlobalTypes.UpgradeType.POWER and powerLevel < maxPwrLevel:
		pwrConsumptionRate /= 1.5;
		powerLevel += 1;
	elif type == GlobalTypes.UpgradeType.COINS and coinLevel < maxCoinLevel:
		initCoinGenRate += 2;
		currentCoinGenRate = initCoinGenRate;
		coinLevel += 1;
	elif type == GlobalTypes.UpgradeType.FLOOR and numFloors < maxFloors:
		var prevLevelTilemap = get_node("Lv%d_Tilemap" % numFloors);
		numFloors += 1;
		var currentLevelTilemap = get_node("Lv%d_Tilemap" % numFloors);
		
		prevLevelTilemap.visible = false;
		currentLevelTilemap.visible = true;

func add_worker() -> void:
	if numWorkers < calc_worker_capacity():
		numWorkers += 1;


func calc_worker_capacity() -> int:
	return 5 * numFloors;


func _on_power_degrade_timer_timeout() -> void:
	if currentPower > 0:
		currentPower -= 1;


func _on_coin_generate_timer_timeout() -> void:
	generateCoins.emit((1 + numWorkers) if currentPower > 0 else 0);
