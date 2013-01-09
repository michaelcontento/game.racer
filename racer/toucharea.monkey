Strict

Private

Import bono

Public

Class TouchArea Implements Touchable, Positionable, Sizeable Abstract
    Private

    Field pos:Vector2D = New Vector2D()
    Field size:Vector2D = New Vector2D()

    Public

    Method GetPosition:Vector2D()
        Return pos
    End

    Method SetPosition:Void(newPos:Vector2D)
        pos = newPos
    End

    Method GetSize:Vector2D()
        Return size
    End

    Method SetSize:Void(newSize:Vector2D)
        size = newSize
    End

    Method GetCenter:Vector2D()
        Return size.Copy().Div(2)
    End

    Method OnTouchDown:Void(event:TouchEvent)
        If IsInside(event.pos) Then OnTouchDownInside(event)
    End

    Method OnTouchMove:Void(event:TouchEvent)
        If IsInside(event.pos) Then OnTouchMoveInside(event)
    End

    Method OnTouchUp:Void(event:TouchEvent)
        If IsInside(event.pos) Then OnTouchUpInside(event)
    End

    Method OnTouchDownInside:Void(event:TouchEvent) Abstract
    Method OnTouchMoveInside:Void(event:TouchEvent) Abstract
    Method OnTouchUpInside:Void(event:TouchEvent) Abstract

    Private

    Method IsInside:Bool(touchPos:Vector2D)
        If touchPos.x < pos.x Then Return False
        If touchPos.y < pos.y Then Return False
        If touchPos.x > pos.x + size.x Then Return False
        If touchPos.y > pos.y + size.y Then Return False
        Return True
    End
End
