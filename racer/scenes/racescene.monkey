Strict

Private

Import bono
Import racer.player
Import racer.road.road

Public

Class RaceScene Extends Scene
    Field player:Player = New Player()

    Method OnSceneEnter:Void()
        AddChild(New Sprite("images/background/sky.png"))
        AddChild(New Sprite("images/background/hills.png"))
        AddChild(New Sprite("images/background/trees.png"))
        AddChild(New Road(player))
        AddChild(player)

        EnableKeyEvents()
    End
End
