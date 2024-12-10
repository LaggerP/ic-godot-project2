extends Node

var music_volume: float = 1
var sfx_volume: float = 1

func _ready() -> void:
	add_to_group("audio_events")
	
func get_music_volume():
	return music_volume
	
func get_sfx_volume():
	return sfx_volume

func set_music_volume(value):
	music_volume = value
	
func set_sfx_volume(value):
	sfx_volume = value
	
	
