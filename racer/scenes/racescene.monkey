Strict

Private

Import bono
Import racer.backgroundsprite
Import racer.button.caraccel
Import racer.button.cardecel
Import racer.keycontrols
Import racer.player
Import racer.road.road

Public

Class RaceScene Extends Scene
    Private

    Field player:Player = New Player()

    Public

    Method OnSceneEnter:Void()
        AddBackground()
        AddTouchControls()
        AddChild(New KeyControls(player))
        AddChild(New Road(player))
        AddChild(player)

        If Target.IS_DEBUG Then AddChild(New FpsCounter())

        If Target.IS_GLFW Or Target.IS_ANDROID
            EnableKeyEvents()
            GetKeyEmitter().showKeyboard = False
        End

        EnableTouchEvents()
        GetTouchEmitter().retainSize = 1
    End

    Private

    Method AddBackground:Void()
        AddChild(New BackgroundSprite("sky.png", New Vector2D(0.001, 0), 0, player))
        AddChild(New BackgroundSprite("hills.png", New Vector2D(0.002, 0.002), 20, player))
        AddChild(New BackgroundSprite("trees.png", New Vector2D(0.003, 0.002), 130, player))
    End

    Method AddTouchControls:Void()
        ' -- ACCEL
        Local accel:ButtonCarAccel = New ButtonCarAccel(player)
        accel.SetSize(New Vector2D(250, 250))
        accel.SetPosition(GetApp().GetVirtualSize())

        Align.Horizontal(accel, Align.RIGHT)
        Align.Vertical(accel, Align.BOTTOM)

        AddChild(accel)

        ' -- DECEL
        Local decel:ButtonCarDecel = New ButtonCarDecel(player)
        decel.SetSize(accel.GetSize())
        decel.GetPosition().y = GetApp().GetVirtualSize().y

        Align.Horizontal(decel, Align.LEFT)
        Align.Vertical(decel, Align.BOTTOM)

        AddChild(decel)
    End
End
