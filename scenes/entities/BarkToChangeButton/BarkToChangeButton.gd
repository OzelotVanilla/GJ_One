@tool
class_name BarkToChangeButton
extends Area2D
## A button that receives bark.


signal pressed

signal bark_received(bark: BarkWave)


@onready var label: Label = $Label

@onready var collision_shape: CollisionShape2D = $StaticBody2D/CollisionShape2D

var area_shape_owner_id := -1


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

    self.syncAreaCollisionShape()

    self.queue_redraw()

func applyFontSize() -> void:
    if not self.is_node_ready():
        return

    self.label.add_theme_font_size_override("font_size", self.font_size)

    self.queue_redraw()

func on_area_entered(area: Area2D):
    if area is BarkWave:
        self.bark_received.emit(area)

func syncAreaCollisionShape() -> void:
    if not self.is_node_ready():
        return

    if self.area_shape_owner_id < 0:
        self.area_shape_owner_id = self.create_shape_owner(self.collision_shape)

    self.shape_owner_clear_shapes(self.area_shape_owner_id)
    self.shape_owner_set_transform(
        self.area_shape_owner_id,
        self.collision_shape.transform
    )
    self.shape_owner_add_shape(
        self.area_shape_owner_id,
        self.collision_shape.shape
    )

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
