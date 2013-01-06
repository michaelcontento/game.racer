Strict

Private

Import bono
Import racer.player

Public

Class BackgroundSprite Extends Sprite
    Private

    Field speed:Float
    Field offset:Float
    Field player:Player

    Public

    Method New(img:String, speed:Float, player:Player)
        Super.New("images/background/" + img)
        Self.speed = speed
        Self.player = player
    End

    Method OnRender:Void()
        GetColor().Activate()

        offset += speed * player.GetCurrentCurvePower()
        If offset > 1 Then offset -= 1
        If offset < 0 Then offset += 1

        Local sourceX:Float = Floor(GetSize().x * offset)
        Local sourceW:Float = Min(GetSize().x, GetSize().x - sourceX)
        DrawImageRect(0, 0, sourceX, 0, sourceW, GetSize().y)

        If sourceW < GetSize().x
            DrawImageRect(sourceW - 1, 0, 0, 0, GetSize().x - sourceW, GetSize().y)
        End

        GetColor().Deactivate()
    End
End
