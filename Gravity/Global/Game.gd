extends Node


var levels: Dictionary = {
	"1": [true, false],
	"2": [false, false],
	"3": [false, false],
	"4": [false, false],
	"5": [false, false],
	"6": [false, false],
	"7": [false, false],
	"8": [false, false],
	"9": [false, false],
	"10": [false, false],
	"11": [false, false],
	"12": [false, false],
	"13": [false, false],
	"14": [false, false],
	"15": [false, false],
	"16": [false, false],
	"17": [false, false],
	"18": [false, false],
	"19": [false, false],
	"20": [false, false],
	"21": [false, false],
	"22": [false, false],
	"23": [false, false],
	"24": [false, false],
	"25": [false, false],
	"26": [false, false],
	"27": [false, false],
	"28": [false, false],
	"29": [false, false],
	"30": [false, false]
}

var MAX_LEVEL = 30
var highestCompletedLevel = 0
var totalCompletedLevels = 0

var selectedSkinIndex = 0

var SKIN_PATHS: Dictionary = {
	"0": "res://Assets/GravityPlayerMeteor.png",
	"1": "res://Assets/Player_Comet.png",
	"2": "res://Assets/Player_Fireball.png",
	"3": "res://Assets/Player_Pink.png"
}

var skin_unlocked: Dictionary = {
	"0": true,
	"1": false,
	"2": false,
	"3": false
}


