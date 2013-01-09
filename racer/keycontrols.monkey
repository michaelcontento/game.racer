Strict

Private

Import bono
Import mojo
Import racer.player

Public

Class KeyControls Implements Keyhandler
    Private

    Field player:Player

    Public

    Method New(player:Player)
        Self.player = player
    End

    Method OnKeyDown:Void(event:KeyEvent)
        Select event.code
        Case KEY_W
            player.ControlAccel(True)
        Case KEY_S
            player.ControlDecel(True)
        Case KEY_A
            player.ControlLeft(True)
        Case KEY_D
            player.ControlRight(True)
        End
    End

    Method OnKeyPress:Void(event:KeyEvent)
    End

    Method OnKeyUp:Void(event:KeyEvent)
        Select event.code
        Case KEY_W
            player.ControlAccel(False)
        Case KEY_S
            player.ControlDecel(False)
        Case KEY_A
            player.ControlLeft(False)
        Case KEY_D
            player.ControlRight(False)
        End
    End
End
