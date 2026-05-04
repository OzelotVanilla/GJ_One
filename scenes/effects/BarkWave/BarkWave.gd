class_name BarkWave
extends Area2D


@export_group("Propagation Settings", "propagation__")

## Unit: [code]px/second[/code].
@export_custom(PropertyHint.PROPERTY_HINT_NONE, "suffix:px/s")
var propagation__speed: float = 800

## When wave is propagated more than this time, it disappears.[br]
## Unit: [code]second[/code].
@export_custom(PropertyHint.PROPERTY_HINT_NONE, "suffix:s")
var propagation__time_limit: float = 0.5

## How small the wave is when it appears.
@export var propagation__initial_scale_ratio: float = 0.15

@export var propagation__fade_threashold := 0.8



@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D

@onready var background_polygon: Polygon2D = $ColourBg


## How long does this wave existed. Read-only.
var time_existed: float = 0

## Original polygon points before propagation scaling.
var initial_polygon: PackedVector2Array


func _ready(): self.__onReady__()
func _physics_process(delta: float) -> void: self.__onPhysicsProcess__(delta)


func __onPhysicsProcess__(delta: float):
    self.time_existed += delta
    if self.time_existed > self.propagation__time_limit:
        self.queue_free()
        return

    self.propagateForward(delta)
    self.updateWaveShape()
    self.updateWaveVisuals()

func propagateForward(delta: float):
    var forward_direction := self.global_transform.x.normalized() # rotation to Vector2 angle.
    self.global_position += forward_direction * self.propagation__speed * delta

func updateWaveShape():
    var progress := self.time_existed / self.propagation__time_limit
    progress = clampf(progress, 0.0, 1.0)

    var scale_ratio := lerpf(
        self.propagation__initial_scale_ratio,
        1.0,
        progress
    )

    var scaled_polygon := PackedVector2Array()
    for point in self.initial_polygon:
        scaled_polygon.append(point * scale_ratio)

    self.collision_polygon_2d.polygon = scaled_polygon

## Sync the visual background polygon from the collision shape's points.
func updateWaveVisuals():
    var progress := self.time_existed / self.propagation__time_limit
    progress = clampf(progress, 0.0, 1.0)

    # Only fade when progress is at 80%.
    if progress > self.propagation__fade_threashold:
        self.background_polygon.modulate.a = \
            (1.0 - progress) / (1.0 - self.propagation__fade_threashold)

    self.background_polygon.polygon = self.collision_polygon_2d.polygon

    self.queue_redraw()

func __onReady__():
    self.initial_polygon = self.collision_polygon_2d.polygon
    self.updateWaveShape()
    self.updateWaveVisuals()
