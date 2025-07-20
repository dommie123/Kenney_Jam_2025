extends Node2D

signal generateCoins;
signal changedPowerTo;
signal updateUI;

@export var maxPower: int;
@export var maxPwrLevel: int;
@export var maxCoinLevel: int;
@export var initCoinGenRate: float;
@export var pwrConsumptionRate: float;
@export var maxFloors: int;
@export var initPwrOvercharge: int;

var currentPower: float;
var currentCoinGenRate: float;
var numWorkers: int;
var numFloors: int;
var powerLevel: int;
var coinLevel: int;
var pwrOvercharge: int;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentPower = maxPower;
	currentCoinGenRate = initCoinGenRate;
	numWorkers = 0;
	numFloors = 1;
	powerLevel = 0;
	coinLevel = 0;
	pwrOvercharge = 0;
	
	$PowerDegradeTimer.wait_time = 1 / pwrConsumptionRate;
	$PowerDegradeTimer.start();
	
	$CoinGenerateTimer.wait_time = 1 / currentCoinGenRate;
	$CoinGenerateTimer.start();
	
	updateUI.emit(numWorkers, calc_worker_capacity(), powerLevel, coinLevel, numFloors, maxFloors);

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
	else:
		return;
	
	updateUI.emit(numWorkers, calc_worker_capacity(), powerLevel, coinLevel, numFloors, maxFloors);


func add_worker() -> void:
	numWorkers += 1;
	updateUI.emit(numWorkers, calc_worker_capacity(), powerLevel, coinLevel, numFloors, maxFloors);


func calc_worker_capacity() -> int:
	return 5 * numFloors;


func _on_power_degrade_timer_timeout() -> void:
	if pwrOvercharge > 0:
		pwrOvercharge -= 1;
	elif currentPower > 0:
		currentPower -= 1;
		changedPowerTo.emit(currentPower)


func _on_coin_generate_timer_timeout() -> void:
	generateCoins.emit((1 + numWorkers) if currentPower > 0 else 0);


func _on_minigame_hud_solved_puzzle() -> void:
	currentPower = maxPower;
	pwrOvercharge = initPwrOvercharge;
	changedPowerTo.emit(currentPower)
