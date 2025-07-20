extends Control

@export var mouseClickSound: AudioStream;
@export var chaChingSound: AudioStream;
@export var buzzerSound: AudioStream;

var coins: int;
var minigameCompleted: bool;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coins = 0;
	minigameCompleted = false;


func _on_building_generate_coins(newCoins: int) -> void:
	coins += newCoins;
	$MainHUD/CoinsContainer/CoinsLabel.text = "Coins: %d" % coins;


func _on_main_hud_toggle_upgrades_menu() -> void:
	if !$MinigameHUD.visible:
		$UpgradesMenu.visible = !$UpgradesMenu.visible;
		play_mouse_click_sound();


func _on_upgrades_menu_try_hire_worker(cost: int) -> void:
	if !checkCanAfford(cost):
		# TODO inform user that they are financially challenged via popup
		print("Oops! You don't have the money to afford that!");
		play_buzzer_sound();
	elif $Building.numWorkers == $Building.calc_worker_capacity():
		print("Oops! You don't have room for any more workers! Please buy more floors first.");
		play_buzzer_sound();
	else:
		coins -= cost;
		$Building.add_worker();
		$MainHUD/CoinsContainer/CoinsLabel.text = "Coins: %d" % coins;
		play_cha_ching_sound();


func _on_upgrades_menu_try_purchase_upgrade(type: GlobalTypes.UpgradeType, cost: int) -> void:
	if !checkCanAfford(cost):
		# TODO inform user that they are financially challenged via popup
		print("Oops! You don't have the money to afford that!");
		play_buzzer_sound();
	elif type == GlobalTypes.UpgradeType.POWER and $Building.powerLevel == $Building.maxPower:
		print("You already have all the upgrades for this item!");
		play_buzzer_sound();
	elif type == GlobalTypes.UpgradeType.COINS and $Building.coinLevel == $Building.maxCoinLevel:
		print("You already have all the upgrades for this item!");
		play_buzzer_sound();
	elif type == GlobalTypes.UpgradeType.FLOOR and $Building.numFloors == $Building.maxFloors:
		print("You can't build any more floors!");
		play_buzzer_sound();
	else:
		coins -= cost;
		$Building.upgrade_building(type)
		$MainHUD/CoinsContainer/CoinsLabel.text = "Coins: %d" % coins;
		
		play_cha_ching_sound();


func checkCanAfford(cost: int) -> bool:
	return coins - cost >= 0;


func _on_building_update_ui(currentWorkers: int, maxWorkers: int, pwrLevel: int, coinsLevel: int, numFloors: int, maxFloors: int) -> void:
	$UpgradesMenu.update_upgrades_menu(currentWorkers, maxWorkers, pwrLevel, coinsLevel, numFloors, maxFloors);


func _on_main_hud_game_paused() -> void:
	get_tree().paused = !get_tree().paused;
	$PauseMenu.visible = get_tree().paused;
	
	play_mouse_click_sound();


func _on_main_hud_minigame_begun() -> void:
	$MinigameHUD.visible = true;
	$UpgradesMenu.visible = false;
	
	play_mouse_click_sound();


func _on_exit_button_pressed() -> void:
	if get_tree().paused:
		get_tree().paused = false;
	
	play_mouse_click_sound();
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")


func play_mouse_click_sound() -> void:
	$GameSFX.stream = mouseClickSound;
	$GameSFX.play();
	

func play_cha_ching_sound() -> void:
	$GameSFX.stream = chaChingSound;
	$GameSFX.play();


func play_buzzer_sound() -> void:
	$GameSFX.stream = buzzerSound;
	$GameSFX.play();


func _on_building_changed_power_to(currentPower: int) -> void:
	$MainHUD/PowerLevel.value = currentPower;
	
	if $GameBGM.playing and currentPower == 0:
		$GameBGM.stop();
	elif !$GameBGM.playing and currentPower > 0:
		$GameBGM.play();
