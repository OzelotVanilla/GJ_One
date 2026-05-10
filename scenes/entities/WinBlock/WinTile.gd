@tool
class_name WinTile
extends Area2D
## A tile that detects player's entering or bark wave as winning signal
##
## Does not collide with player.


## Emit when player can wan.
signal player_can_win()


@onready var sprite: Sprite2D = $Sprite2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@onready var name_label: Label = $Debug/NameLabel


func _ready() -> void: self.__onReady__()


## Sync the size of sprite to other components.
func syncSize():
    var size := self.sprite.get_rect().size * self.sprite.scale.abs()

    self.collision_shape.scale = Vector2.ONE

    var collision_rect := self.collision_shape.shape as RectangleShape2D
    if collision_rect != null:
        collision_rect.size = size

    self.name_label.position = -size / 2.0
    self.name_label.size = size

    self.queue_redraw()

## Called when [BarkWave] enters win tile.
func on_BarkWave_enterted(bark_wave: BarkWave):
    # Blocks the propagation of bark wave.
    if bark_wave == null:
        return

    match bark_wave.ability.to_lower():
        "touch", "press":
            self.player_can_win.emit()

func on_body_entered(body: Node) -> void:
    if body is WanCat:
        self.player_can_win.emit()

func __onReady__():
    if Engine.is_editor_hint():
        self.set_process(false)
        self.set_physics_process(false)

    self.syncSize()
