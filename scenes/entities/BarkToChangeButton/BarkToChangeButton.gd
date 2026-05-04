@tool
class_name BarkToChangeButton
extends Area2D
## A button that receives bark.


signal pressed

signal bark_received(bark: BarkWave)


@onready var label: Label = $Label

@onready var collision_shape: CollisionShape2D = $CollisionShape2D


## Size of button
@export var size: Vector2 = Vector2(128, 48):
    set(new_size):
        size = new_size
        self.applySize()

@export_multiline var text: String = "BUTTON":
    set(new_text):
        text = new_text
        self.applyText()

@export_custom(PropertyHint.PROPERTY_HINT_NONE, "suffix:px")
var font_size: int = 16:
    set(new_size):
        font_size = new_size
        self.applyFontSize()


func _draw() -> void: self.__onDraw__()
func _ready() -> void: self.__onReady__()


func applyText() -> void:
    if not self.is_node_ready():
        return

    self.label.text = self.text

    self.queue_redraw()

func applySize() -> void:
    if not self.is_node_ready():
        return

    self.label.position = -self.size / 2.0
    self.label.size = self.size

    var collision_rect := self.collision_shape.shape as RectangleShape2D
    if collision_rect != null:
        collision_rect.size = self.size

    self.queue_redraw()

func applyFontSize() -> void:
    if not self.is_node_ready():
        return

    self.label.add_theme_font_size_override("font_size", self.font_size)

    self.queue_redraw()

func on_area_entered(area: Area2D):
    if area is BarkWave:
        self.bark_received.emit(area)

## Connected from self [signal input_event].
func on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
    if event is InputEventMouseButton:
        if event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed:
            self.pressed.emit()

func __onDraw__() -> void:
    var rect := Rect2(-self.size / 2.0, self.size)
    draw_rect(rect, Color("#ffffff"), true)
    draw_rect(rect, Color("#000000"), false, 2)

func __onReady__() -> void:
    self.applyText()
    self.applySize()
    self.applyFontSize()
