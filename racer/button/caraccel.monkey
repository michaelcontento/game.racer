Strict

Private

Import bono
Import racer.player
Import racer.toucharea

Public

Class ButtonCarAccel Extends TouchArea Implements Updateable
    Private

    Field player:Player
    Field active:Bool

    Public

    Method New(player:Player)
        Self.player = player
    End

    Method OnUpdate:Void(timer:DeltaTimer)
        If active Then player.ControlAccel(True)
    End

    Method OnTouchDownInside:Void(event:TouchEvent)
        active = True
    End

    Method OnTouchMoveInside:Void(event:TouchEvent)
    End

    Method OnTouchUpInside:Void(event:TouchEvent)
    End

    Method OnTouchUp:Void(event:TouchEvent)
        active = False
        player.ControlAccel(False)
    End
End
