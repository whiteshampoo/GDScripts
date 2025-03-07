class_name TimeUtil extends Node

## Returns a string describing passed time since the engine has started.
static func timestamp(include_ms: bool = true) -> String:
	var ms: int = Time.get_ticks_msec()
	return get_timestr_from_ms(ms, include_ms)

## Returns a string representation based on given miliseconds, optionally only up to second accuracy.
## Format will be either h:mm:ss or h:mm:ss.f, depending on [code]include_ms_in_result[/code].
static func get_timestr_from_ms(ms: int, include_ms_in_result: bool = true) -> String:
	@warning_ignore("integer_division")
	var time_str: String = str(ms/3600000)+":"+str(ms/60000).pad_zeros(2)+":"+str(ms/1000).pad_zeros(2)
	if include_ms_in_result:
		var ms_str: String = str(ms)
		ms_str.erase(ms_str.length() - 1, 1)
		time_str = time_str + "." + ms_str
	return time_str
