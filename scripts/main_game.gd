extends Control

var coins: int;
var minigameCompleted: bool;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coins = 0;
	minigameCompleted = false;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_building_generate_coins(newCoins: int) -> void:
	coins += newCoins;
	$MainHUD/CoinsContainer/CoinsLabel.text = "Coins: %d" % coins;
