Strict

Private

Import bono
Import racer.road.road

Public

Class RaceScene Extends Scene
    Method OnSceneEnter:Void()
        AddChild(New Road())
    End
End
