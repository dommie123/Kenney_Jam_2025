extends Control

var GameScene: PackedScene = preload("res://scenes/main_game.tscn");

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(GameScene);
