extends Node2D
class_name CameraContainer2D, 'res://CameraContainer2D/CameraContainer2D.svg'
tool


var shake_duration = 0.0
var period_in_ms = 0.0
var amplitude = 0.0
var remaining_shake_time = 0.0
var last_shook_timer = 0
var old_direction = Vector2(0, 0)
var old_camera_position = Vector2(0, 0)


var camera_target = null

onready var NCamera = get_node('Camera2D')


"""
HOW TO USE
func _ready() -> void:
	$CameraContainer2D.set_camera_target('/root/Level_1/Shadow/PlayerSprite/Position2D', Vector2(Tween.TRANS_CUBIC, Tween.EASE_IN_OUT), 3)
"""


func _ready() -> void:
	self.add_child(Tween.new(), true)


func _get_configuration_warning():
	if self.has_node('Camera2D') == false:
		return 'Add a Camera2D'
	
	return ''



func _process(delta: float) -> void:
	if Engine.editor_hint == false:
		_follow_target()
		_camera_shake(delta)



func _follow_target():
	if camera_target != null:
		self.global_position = camera_target.global_position




func set_camera_target(new_target: NodePath, transition_types: Vector2, speed_of_transition: float):
	camera_target = null
	
	if new_target != null:
		
		get_node('Tween').interpolate_property(
			self, 'position', self.global_position,
			get_node(new_target).global_position,
			speed_of_transition, transition_types.x, transition_types.y)
		
		get_node('Tween').start()
		
		yield(get_node('Tween'), 'tween_completed')
		
		camera_target = get_node(new_target)



# Shake with decreasing intensity while there's time remaining.
func _camera_shake(delta):
	
	if remaining_shake_time == 0:
		return
	
	last_shook_timer += delta
	
	
	if last_shook_timer >= period_in_ms:
#		last_shook_timer is the distance between movement spikes
		last_shook_timer -= period_in_ms
		
		
		var time_left_to_shake = shake_duration - remaining_shake_time
		var zero_to_one = time_left_to_shake / shake_duration
		
		
		var one_to_zero = 1 - zero_to_one
		
		
		var amplitude_to_zero = amplitude * one_to_zero
		
		
		var new_direction = Vector2(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0))
		
		
		var continue_or_reverse_direction = new_direction - old_direction #-2 to 2
		var distance_from_zero = old_direction + (delta * continue_or_reverse_direction)
		
		
		var new_camera_position = Vector2.ZERO
		new_camera_position = amplitude_to_zero * distance_from_zero
		
		
		NCamera.set_offset(Vector2.ZERO)
		NCamera.set_offset(new_camera_position)
		
		
		old_camera_position = new_camera_position
		old_direction = new_direction
	
	
	remaining_shake_time -= delta
	
	
	if remaining_shake_time <= 0:
		remaining_shake_time = 0
		NCamera.set_offset(Vector2.ZERO)
		old_camera_position = Vector2.ZERO
	





func shake(Duration : float, Frequency : float, Amplitude : float):
	
	shake_duration = Duration
	remaining_shake_time = Duration
	period_in_ms = 1.0 / Frequency
	amplitude = Amplitude
	old_direction = Vector2(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0))







