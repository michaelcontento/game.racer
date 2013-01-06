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
        AddChild(New BackgroundSprite("sky.png", 0.001, player))
        AddChild(New BackgroundSprite("hills.png", 0.002, player))
        AddChild(New BackgroundSprite("trees.png", 0.003, player))
        AddChild(New Road(player))
        AddChild(player)

        EnableKeyEvents()
    End
End
