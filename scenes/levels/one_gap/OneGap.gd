extends BaseLevel


@onready var wancat_spawn_position: Marker2D = $WanCatSpawnPosition

@onready var win_tile: WinTile = $WinTile


func __onPlayerCanWin__():
    print("Win")

func __onReady__() -> void:
    self.spawnWanCat(
        self.wancat_spawn_position.global_position,
        Vector2.LEFT
    )

    if not self.win_tile.player_can_win.is_connected(self.__onPlayerCanWin__):
        self.win_tile.player_can_win.connect(self.__onPlayerCanWin__)

func __onWanCatReady__() -> void:
    self.wancat.bark_ability_list = [
        "TOUCH"
    ]

    self.wancat.current_bark_ability_index = 0
