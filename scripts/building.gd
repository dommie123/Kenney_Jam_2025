extends Node2D

signal generateCoins;
signal changedPowerTo;
signal updateUI;

@export var maxPower: int;
@export var maxPwrLevel: int;
@export var initPwrOvercharge: int;
@export var maxCoinLevel: int;
@export var initCoinGenRate: float;
@export var pwrConsumptionRate: float;
@export var maxFloors: int;
@export var floorTilemaps: Array[Node2D];

var currentPower: float;
var pwrOvercharge: int;
var currentCoinGenRate: float;
var numWorkers: int;
var numFloors: int;
var powerLevel: int;
var coinLevel: int;

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
		numFloors += 1;
		
		# TODO just figure this out in Version 2.0
		#if numFloors - 1 == 1:
			#$Lv1_Tilemap/TileMapBackground.hide();
			#$Lv1_Tilemap/TileMapForeground.hide();
			#$Lv2_Tilemap/TileMapBackground.show();
			#$Lv2_Tilemap/TileMapForeground.show();
		#elif numFloors - 1 == 2:
			#$Lv2_Tilemap/TileMapBackground.hide();
			#$Lv2_Tilemap/TileMapForeground.hide();
			#$Lv3_Tilemap/TileMapBackground.show();
			#$Lv3_Tilemap/TileMapForeground.show();
		#elif numFloors - 1 == 3:
			#$Lv3_Tilemap/TileMapBackground.hide();
			#$Lv3_Tilemap/TileMapForeground.hide();
			#$Lv4_Tilemap/TileMapBackground.show();
			#$Lv4_Tilemap/TileMapForeground.show();
		#elif numFloors - 1 == 4:
			#$Lv4_Tilemap/TileMapBackground.hide();
			#$Lv4_Tilemap/TileMapForeground.hide();
			#$Lv5_Tilemap/TileMapBackground.show();
			#$Lv5_Tilemap/TileMapForeground.show();
		
		# Force Godot to redraw the building asset, 
		# hoping the tilemaps will actually update this time.
		queue_redraw();
	else:
		return;
	
	$PowerDegradeTimer.wait_time = 1 / pwrConsumptionRate;
	$CoinGenerateTimer.wait_time = 1 / currentCoinGenRate;
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
