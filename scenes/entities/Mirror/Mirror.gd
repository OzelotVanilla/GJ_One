@tool
class_name Mirror
extends RigidBody2D


const bark_wave__scene := preload("res://scenes/effects/BarkWave/BarkWave.tscn")

const reflection__angle_threshold := PI / 4.0

const reflection__spawn_offset := 12.0


@onready var sprite: Sprite2D = $Sprite2D

@onready var collision_polygon: CollisionPolygon2D = $CollisionPolygon2D

@onready var reflection_area : MirrorReflectionArea = $ReflectionArea

@onready var reflection_area__collision_shape: CollisionShape2D = \
    $ReflectionArea/CollisionShape2D

@onready var reflection_area__center_marker: Marker2D = $ReflectionArea/CenterMarker


func _ready() -> void: self.__onReady__()


## Sync the size of sprite to other components.
func syncSize() -> void:
    if not is_node_ready():
        return

    var sprite_scale := self.sprite.scale

    self.collision_polygon.scale = sprite_scale

    self.reflection_area__collision_shape.scale = sprite_scale
    self.reflection_area__collision_shape.position = Vector2(0, -50) * sprite_scale
    self.reflection_area__center_marker.position = Vector2(0, -50) * sprite_scale \
        + Vector2(0, -20) * sprite_scale # Give a bit offset, otherwise the wave stuck.

    self.queue_redraw()

## Called when [BarkWave] enters mirror.
func on_BarkWave_enterted(bark_wave: BarkWave) -> void:
    if bark_wave == null:
        return

    match bark_wave.ability.to_lower():
        "rotate":
            self.rotate(deg_to_rad(45))

func on_ReflectionArea_BarkWave_received(bark_wave: BarkWave):
    if bark_wave == null or not is_instance_valid(bark_wave):
        return

    # # Do not handle special ability wave.
    match bark_wave.ability.to_lower():
        "rotate":
            return

    var incoming_angle := wrapf(bark_wave.rotation - PI, -PI, PI)
    var incoming_diff := angle_difference(
        self.rotation - PI / 2,
        incoming_angle
    )

    if absf(incoming_diff) > Mirror.reflection__angle_threshold:
        self.clearBarkWave(bark_wave)
        return

    var new_wave_ability := bark_wave.ability
    var mirror_middle_angle := self.rotation
    var new_wave_rotation := (mirror_middle_angle - PI / 4 \
        if incoming_diff > 0 else \
        mirror_middle_angle + PI / 4)
    var new_wave_position := self.reflection_area__center_marker.global_position \
        + Vector2.RIGHT.rotated(new_wave_rotation) * Mirror.reflection__spawn_offset

    self.clearBarkWave(bark_wave)

    # # Create new.
    var action := func():
        var new_wave: BarkWave = Mirror.bark_wave__scene.instantiate()
        self.get_parent().add_child(new_wave)
        new_wave.global_position = new_wave_position
        new_wave.rotation = new_wave_rotation - PI / 2
        new_wave.ability = new_wave_ability
        new_wave.collision_check__time_threshold = 0.1
    action.call_deferred()

func clearBarkWave(bark_wave: BarkWave) -> void:
    if bark_wave == null or not is_instance_valid(bark_wave):
        return

    bark_wave.set_deferred("monitoring", false)
    bark_wave.set_deferred("monitorable", false)

    for child in bark_wave.get_children():
        if child is Area2D:
            child.set_deferred("monitoring", false)
            child.set_deferred("monitorable", false)

    bark_wave.queue_free()

func __onReady__() -> void:
    if Engine.is_editor_hint():
        self.set_process(false)
        self.set_physics_process(false)
        return

    self.syncSize()
    self.reflection_area.mirror__ref = self
