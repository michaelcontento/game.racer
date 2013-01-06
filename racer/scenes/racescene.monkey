Strict

Private

Import bono
Import racer.player
Import racer.road.road
Import racer.backgroundsprite

Public

Class RaceScene Extends Scene
    Field player:Player = New Player()

    Method OnSceneEnter:Void()
        AddChild(New BackgroundSprite("sky.png", New Vector2D(0.001, 0), 0, player))
        AddChild(New BackgroundSprite("hills.png", New Vector2D(0.002, 0.002), 20, player))
        AddChild(New BackgroundSprite("trees.png", New Vector2D(0.003, 0.002), 130, player))
        AddChild(New Road(player))
        AddChild(player)

        EnableKeyEvents()
    End
End
