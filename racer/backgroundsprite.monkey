Strict

Private

Import bono
Import racer.player

Public

Class BackgroundSprite Extends Sprite
    Private

    Const RESOLUTION:Float = 1.6
    Field speed:Vector2D
    Field offset:Float
    Field player:Player
    Field yOffsetEnabled:Bool = True
    Field posY:Float

    Public

    Method New(img:String, speed:Vector2D, posY:Float, player:Player)
        Super.New("images/background/" + img)
        Self.speed = speed
        Self.player = player
        Self.posY = posY
    End

    Method OnRender:Void()
        GetColor().Activate()

        offset += speed.x * player.GetCurrentCurvePower()
        If offset > 1 Then offset -= 1
        If offset < 0 Then offset += 1

        Local dstY:Float = posY + (player.y * speed.y * RESOLUTION)
        Local sourceX:Float = Floor(GetSize().x * offset)
        Local sourceW:Float = Min(GetSize().x, GetSize().x - sourceX)
        DrawImageRect(0, dstY, sourceX, 0, sourceW, GetSize().y)

        If sourceW < GetSize().x
            DrawImageRect(sourceW - 1, dstY, 0, 0, GetSize().x - sourceW, GetSize().y)
        End

        GetColor().Deactivate()
    End
End
