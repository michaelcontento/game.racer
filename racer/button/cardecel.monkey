Strict

Private

Import bono
Import racer.player
Import racer.toucharea

Public

Class ButtonCarDecel Extends TouchArea Implements Updateable
    Private

    Field player:Player
    Field active:Bool

    Public

    Method New(player:Player)
        Self.player = player
    End

    Method OnUpdate:Void(timer:DeltaTimer)
        If active Then player.ControlDecel(True)
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
        player.ControlDecel(False)
    End
End
