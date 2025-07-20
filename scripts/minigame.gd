extends NinePatchRect

signal solvedPuzzle; 	# Trigger this when the player solves the puzzle.

@export var switches: Array[CheckButton];
@export var checkedIcon: Texture2D;
@export var successIcon: Texture2D;
@export var switchSoundLibrary: Array[AudioStream];
@export var mouseClickSound: AudioStream;

var puzzleSolved: bool; # Has the puzzle been solved yet?
var puzzleMatrix;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	puzzleSolved = false; # For Debug Purposes
	puzzleMatrix = [
		[false, false, false],
		[false, false, false],
		[false, false, false],
	]
	
	reset_puzzle();
			

func _process(delta: float) -> void:
	if puzzleSolved:
		solvedPuzzle.emit();
		for switch in switches:
			switch.disabled = true;
		if $DisappearAfterSeconds.is_stopped():
			$DisappearAfterSeconds.start();


func check_puzzle_solved() -> bool:
	var i = 0;
	var j = 0;
	while i < puzzleMatrix.size():
		while j < puzzleMatrix[i].size():
			if !puzzleMatrix[i][j]:
				return false;
			j += 1;
		j = 0;
		i += 1;
	
	return true;


func _on_disappear_after_seconds_timeout() -> void:
	visible = false;
	for switch in switches:
		switch.disabled = false;
	
	reset_puzzle();


func _on_close_button_pressed() -> void:
	$SFXPlayer.stream = mouseClickSound;
	$SFXPlayer.play();
	
	visible = false;
	for switch in switches:
		switch.disabled = false;
	
	reset_puzzle();

func _on_checked_button_pressed(button_name: String) -> void:
	play_random_sound();
	
	var coords = button_name.substr(11, 13);
	var xCoord = int(coords.split("_")[0]);
	var yCoord = int(coords.split("_")[1]);
	puzzleMatrix[xCoord][yCoord] = !puzzleMatrix[xCoord][yCoord];
	
	var neighbor_offsets = [
		[-1, 0],   # Top
		[0, -1],    # Left
		[0, 1],     # Right
		[1, 0],    # Bottom
	]
	
	for offset in neighbor_offsets:
		var neighbor_row = xCoord + offset[0]
		var neighbor_col = yCoord + offset[1]

		# Check for out-of-bounds
		if (neighbor_row >= 0 and neighbor_row < puzzleMatrix.size() and
			neighbor_col >= 0 and neighbor_col < puzzleMatrix[0].size()):
			puzzleMatrix[neighbor_row][neighbor_col] = !puzzleMatrix[neighbor_row][neighbor_col];
			
	
	refresh_buttons();
	puzzleSolved = check_puzzle_solved();

func refresh_buttons() -> void:
	var i = 0;
	var j = 0;
	
	while i < puzzleMatrix.size():
		while j < puzzleMatrix.size():
			var checkedButton = get_node("CheckButton%d_%d" % [i, j]);
			checkedButton.button_pressed = puzzleMatrix[i][j];
			j += 1;
		j = 0;
		i += 1;


func reset_puzzle() -> void:
	puzzleSolved = false;
	
	# Flip up to three switches at random so no two puzzles are the same.
	var switchesToFlip = randi_range(1, 3);
	var i = 0; 
	var j = 0;
	var counter = 0;
	while i < puzzleMatrix.size():
		while j < puzzleMatrix[i].size():
			var totalSwitches = puzzleMatrix.size() * puzzleMatrix[0].size();
			if totalSwitches - counter == switchesToFlip or (randi_range(0, 1) == 1 and switchesToFlip > 0):
				puzzleMatrix[i][j] = true;
				switchesToFlip -= 1;
			else:
				puzzleMatrix[i][j] = false;
			j += 1;
			counter += 1;
		j = 0;
		i += 1;
	
	i = 0;
	while i < switches.size():
		switches[i].pressed.connect(_on_checked_button_pressed.bind(switches[i].name));
		i += 1;
	
	refresh_buttons();


func play_random_sound() -> void:
	var index = randi_range(0, switchSoundLibrary.size() - 1);
	$SFXPlayer.stream = switchSoundLibrary[index];
	$SFXPlayer.play();
