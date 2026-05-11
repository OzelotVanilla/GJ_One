class_name WanText
extends Node2D


@export_custom(PropertyHint.PROPERTY_HINT_NONE, "suffix:s")
var text_lasting_time: float = 0.5


@onready var text__en: Sprite2D = $EN

@onready var text__jp: Sprite2D = $JP


## How long does this text existed. Read-only.
var time_existed: float = 0


func _process(delta: float) -> void: self.__onProcess__(delta)


func __onProcess__(delta: float):
    # # Float the text and disappear
    self.time_existed += delta
    if self.time_existed > self.text_lasting_time:
        self.queue_free()
        return

    var progress := self.time_existed / self.text_lasting_time
    progress = clampf(progress, 0.0, 1.0)

    self.global_position = self.global_position + Vector2.UP * 2
    var scale_value := 1 + progress * 2.0
    self.scale = Vector2(scale_value, scale_value)
    if progress > 0.8:
        self.modulate.a = (1.0 - progress) / 0.2
