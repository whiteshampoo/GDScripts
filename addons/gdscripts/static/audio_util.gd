class_name AudioUtil extends Object

## Returns the best audio player in the given array. This will directly return an audio stream player if it is not playing.
## Otherwise it favors audio stream players that have progressed the most.
## Note: This is untyped due to AudioStreamPlayer, AudioStreamPlayer2D and AudioStreamPlayer3D not sharing a common base class.
static func get_most_free_audio_node(audio_stream_players: Array) -> Node:
	var most_progress: float = 0
	var most_progress_player: Node = null
	for target_player: Node in audio_stream_players:
		if _is_free(target_player):
			return target_player
		
		var current_progress: float = _get_progress(target_player)
		if current_progress > most_progress:
			most_progress = current_progress
			most_progress_player = target_player
			
	return most_progress_player

## Returns the first audio player in the given array that is not playing, or null if there is no free audio player.
## Note: This is untyped due to AudioStreamPlayer, AudioStreamPlayer2D and AudioStreamPlayer3D not sharing a common base class.
static func get_free_audio_stream_player_or_null(target_audio_players: Array) -> Node:
	var free_players: Array = target_audio_players.filter(_is_free)
	if free_players.size() > 0:
		return free_players[0]
	return null
	
static func _is_free(audio_stream_player: Node) -> bool:
	return audio_stream_player.playing

static func _get_progress(audio_stream_player: Node) -> float:
	return audio_stream_player.get_playback_position() / audio_stream_player.stream.get_length()
